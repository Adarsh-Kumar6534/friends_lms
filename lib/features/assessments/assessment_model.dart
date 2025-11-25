import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      answer: map['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
    };
  }
}

class Assessment {
  final String id;
  final String title;
  final String course;
  final String level;
  final List<Question> questions;
  final String status; // Pending, Completed, Upcoming
  final DateTime? dueDate;

  Assessment({
    required this.id,
    required this.title,
    required this.course,
    required this.level,
    required this.questions,
    this.status = 'Pending',
    this.dueDate,
  });

  factory Assessment.fromMap(Map<String, dynamic> map, String id) {
    return Assessment(
      id: id,
      title: map['title'] ?? '',
      course: map['course'] ?? '',
      level: map['level'] ?? '',
      questions: (map['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromMap(q))
              .toList() ??
          [],
      status: map['status'] ?? 'Pending',
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'course': course,
      'level': level,
      'questions': questions.map((q) => q.toMap()).toList(),
      'status': status,
      'dueDate': dueDate,
    };
  }
}
