import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'reminder_repository.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.read(firestoreProvider));
});

final userRemindersProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, uid) {
  return ref.read(reminderRepositoryProvider).getUserReminders(uid);
});
