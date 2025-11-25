import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FileManagerRepository {
  final SupabaseClient _supabase;

  FileManagerRepository(this._supabase);

  Future<List<Map<String, dynamic>>> getFiles({String searchQuery = ''}) async {
    try {
      print('FileManagerRepository: Fetching files with query: "$searchQuery"');
      
      var query = _supabase
          .from('user_uploaded_files')
          .select();

      if (searchQuery.isNotEmpty) {
        final searchPattern = '%$searchQuery%';
        query = query.or('topic_name.ilike.$searchPattern,course_name.ilike.$searchPattern');
      }
      
      // Apply ordering last
      final orderedQuery = query.order('uploaded_at', ascending: false);

      final List<dynamic> response = await orderedQuery;
      
      return response.map((e) {
        final data = e as Map<String, dynamic>;
        return {
          'id': data['id'],
          'name': data['file_name'] ?? data['topic_name'] ?? 'Unknown', // Map file_name
          'topicName': data['topic_name'],
          'courseName': data['course_name'],
          'uploaderName': data['uploader_name'],
          'url': data['file_url'],
          'type': data['file_type'],
          'size': data['file_size'],
          'uploadedAt': data['uploaded_at'] != null ? DateTime.parse(data['uploaded_at']) : null,
        };
      }).toList();
    } catch (e) {
      print('Error fetching files: $e');
      return [];
    }
  }

  Future<void> uploadFile({
    required String uid,
    File? file,
    Uint8List? fileBytes,
    required String fileName,
    required String topicName,
    required String courseName,
    required String uploaderName,
  }) async {
    try {
      if (file == null && fileBytes == null) {
        throw Exception('No file data provided');
      }

      // 1. Check size (3MB limit)
      int fileSize = 0;
      if (fileBytes != null) {
        fileSize = fileBytes.length;
      } else if (file != null) {
        fileSize = await file.length();
      }

      const int maxSizeBytes = 3 * 1024 * 1024; // 3 MB
      if (fileSize > maxSizeBytes) {
        throw Exception('File size too large. Maximum allowed size is 3 MB.');
      }

      // 2. Upload to Supabase Storage
      final uuid = const Uuid().v4();
      final path = '$uid/${uuid}_$fileName';
      
      if (fileBytes != null) {
        await _supabase.storage.from('files').uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );
      } else {
        await _supabase.storage.from('files').upload(
          path,
          file!,
          fileOptions: const FileOptions(upsert: true),
        );
      }

      // 3. Get Public URL
      final publicUrl = _supabase.storage.from('files').getPublicUrl(path);

      // 4. Insert metadata
      final fileExtension = fileName.split('.').last;
      
      await _supabase.from('user_uploaded_files').insert({
        'user_id': uid,
        'file_name': fileName, // Store filename
        'topic_name': topicName,
        'course_name': courseName,
        'uploader_name': uploaderName,
        'file_url': publicUrl,
        'file_type': fileExtension,
        'file_size': fileSize,
      });

    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  Future<void> deleteFile(String uid, String fileId, String fileName) async {
    try {
      await _supabase.from('user_uploaded_files').delete().eq('id', fileId);
    } catch (e) {
      print('Error deleting file: $e');
      throw Exception('Failed to delete file: $e');
    }
  }
}
