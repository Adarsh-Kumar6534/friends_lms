import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_provider.dart';
import 'assessment_repository.dart';
import 'assessment_model.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(ref.read(firestoreProvider));
});

final assessmentsProvider = StreamProvider<List<Assessment>>((ref) {
  final repository = ref.read(assessmentRepositoryProvider);
  // Trigger seeding if needed (fire and forget, or handle properly in init)
  repository.seedAssessments();
  return repository.getAssessments();
});
