import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderRepository {
  final FirebaseFirestore _firestore;

  ReminderRepository(this._firestore);

  Future<void> addReminder({
    required String uid,
    required String title,
    required String type,
    required int daysBefore,
    required int frequencyPerDay,
    required String email,
    required DateTime eventDate,
  }) async {
    await _firestore.collection('reminders').add({
      'uid': uid,
      'title': title,
      'type': type,
      'daysBefore': daysBefore,
      'frequencyPerDay': frequencyPerDay,
      'email': email,
      'eventDate': Timestamp.fromDate(eventDate),
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  Stream<List<Map<String, dynamic>>> getUserReminders(String uid) {
    return _firestore
        .collection('reminders')
        .where('uid', isEqualTo: uid)
        .orderBy('eventDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
