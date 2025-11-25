import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assessment_model.dart';

class AssessmentRepository {
  final FirebaseFirestore _firestore;

  AssessmentRepository(this._firestore);

  Stream<List<Assessment>> getAssessments() {
    return _firestore.collection('assessments').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Assessment.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> seedAssessments() async {
    final snapshot = await _firestore.collection('assessments').limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Already seeded

    try {
      final String response =
          await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> data = json.decode(response);

      for (var subject in data.keys) {
        final levels = data[subject] as Map<String, dynamic>;
        for (var level in levels.keys) {
          final questionsList = levels[level] as List<dynamic>;
          final questions =
              questionsList.map((q) => Question.fromMap(q)).toList();

          await _firestore.collection('assessments').add({
            'title': '$subject Quiz - Level $level',
            'course': subject,
            'level': level,
            'questions': questions.map((q) => q.toMap()).toList(),
            'status': 'Pending',
            'dueDate': DateTime.now().add(const Duration(days: 7)),
          });
        }
      }
    } catch (e) {
      print("Error seeding assessments: $e");
    }
  }
}
