import '../repositories/story_repository.dart';

class DoLogout {
  final StoryRepository repository;

  const DoLogout(this.repository);

  /// Remove log in token from the app cache.
  ///
  /// Return false if fail.
  Future<bool> execute() => repository.doLogout();
}
