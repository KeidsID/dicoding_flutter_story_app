import 'package:core/core.dart';
import '../repositories/story_repository.dart';

class DoLogout {
  final StoryRepository repository;

  const DoLogout(this.repository);

  /// Remove log in token from the app cache.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> execute() => repository.doLogout();
}
