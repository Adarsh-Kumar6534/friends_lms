import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesRepository {
  final FirebaseFirestore _firestore;

  CoursesRepository(this._firestore);

  Stream<List<Map<String, dynamic>>> getCourses() {
    return _firestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> enrollInCourse(String uid, String courseId) async {
    await _firestore.collection('users').doc(uid).update({
      'enrolled_courses': FieldValue.arrayUnion([courseId])
    });
  }
}
