import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_provider.dart';
import 'courses_repository.dart';

final coursesRepositoryProvider = Provider<CoursesRepository>((ref) {
  return CoursesRepository(ref.read(firestoreProvider));
});

final coursesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(coursesRepositoryProvider).getCourses();
});
