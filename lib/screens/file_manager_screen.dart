import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileManagerScreen extends StatefulWidget {
  final String userType; // Add userType parameter
  const FileManagerScreen(
      {super.key, required this.userType}); // Update constructor

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();

  List<Map<String, String>> uploadedFiles = [];

  Future<void> _pickAndUploadFile() async {
    if (_courseController.text.isEmpty ||
        _chapterController.text.isEmpty ||
        _topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields before uploading")),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null && result.files.first.size <= 5 * 1024 * 1024) {
      setState(() {
        uploadedFiles.add({
          'name': result.files.first.name,
          'course': _courseController.text,
          'topic': _topicController.text
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File too large. Max 5MB allowed.")),
      );
    }
  }

  List<Map<String, String>> get filteredFiles {
    String course = _courseController.text.trim().toLowerCase();
    String topic = _topicController.text.trim().toLowerCase();
    return uploadedFiles.where((file) {
      return (file['course']!.toLowerCase().contains(course)) &&
          (file['topic']!.toLowerCase().contains(topic));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "File Manager",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Upload, organize, and share learning resources",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _courseController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Course"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _chapterController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Chapter Name"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _topicController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Topic Name"),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _pickAndUploadFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                  ),
                  child: const Text("Upload"),
                )
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF12161D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recent Files",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 12),
                  if (filteredFiles.isEmpty)
                    Column(
                      children: const [
                        Icon(Icons.insert_drive_file,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("No files found",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        Text("Upload some files to get started",
                            style: TextStyle(color: Colors.grey))
                      ],
                    )
                  else
                    Column(
                      children: filteredFiles
                          .map((file) => ListTile(
                                leading: const Icon(Icons.description,
                                    color: Colors.white),
                                title: Text(file['name']!,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  "${file['course']} > ${file['topic']}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.download,
                                      color: Colors.white),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Simulating download of ${file['name']}")),
                                    );
                                  },
                                ),
                              ))
                          .toList(),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF10B981)),
      ),
    );
  }
}
