import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore;

  DashboardRepository(this._firestore);

  Stream<Map<String, dynamic>> getUserStats(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return {};
      return doc.data()?['stats'] ?? {};
    });
  }

  Future<List<Map<String, dynamic>>> getRecommendedCourses() async {
    // In a real app, this would query based on user interests
    final snapshot = await _firestore.collection('courses').limit(3).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateUserStats(String uid, Map<String, dynamic> newStats) async {
    await _firestore.collection('users').doc(uid).set({
      'stats': newStats,
    }, SetOptions(merge: true));
  }
}
