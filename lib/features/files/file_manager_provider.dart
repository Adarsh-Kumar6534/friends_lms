import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'file_manager_repository.dart';

final fileManagerRepositoryProvider = Provider<FileManagerRepository>((ref) {
  return FileManagerRepository(
    ref.read(supabaseClientProvider),
  );
});

final userFilesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, searchQuery) {
  return ref.read(fileManagerRepositoryProvider).getFiles(searchQuery: searchQuery);
});
