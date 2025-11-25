import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_provider.dart';
import 'dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.read(firestoreProvider));
});

final userStatsProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, uid) {
  return ref.read(dashboardRepositoryProvider).getUserStats(uid);
});

final recommendedCoursesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(dashboardRepositoryProvider).getRecommendedCourses();
});
