import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import 'discussion_repository.dart';

final discussionRepositoryProvider = Provider<DiscussionRepository>((ref) {
  return DiscussionRepository(ref.read(supabaseClientProvider));
});

final discussionMessagesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(discussionRepositoryProvider).getMessages();
});
