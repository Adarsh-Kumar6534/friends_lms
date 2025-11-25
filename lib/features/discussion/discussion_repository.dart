import 'package:supabase_flutter/supabase_flutter.dart';

class DiscussionRepository {
  final SupabaseClient _supabase;

  DiscussionRepository(this._supabase);

  Stream<List<Map<String, dynamic>>> getMessages() {
    // Initial fetch
    final stream = _supabase
        .from('discussion_messages')
        .stream(primaryKey: ['id'])
        .order('sent_at', ascending: true)
        .map((List<Map<String, dynamic>> data) {
          return data;
        });
        
    return stream;
  }

  Future<void> sendMessage(String uid, String userName, String message) async {
    try {
      await _supabase.from('discussion_messages').insert({
        'user_id': uid,
        'message': message,
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}
