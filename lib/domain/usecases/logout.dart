import '../repositories/story_repository.dart';

class Logout {
  final StoryRepository repository;

  const Logout(this.repository);

  /// Remove log in token from the app cache.
  ///
  /// Return false if fail.
  Future<bool> execute() => repository.logout();
}
