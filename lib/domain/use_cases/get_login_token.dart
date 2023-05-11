import '../repositories/story_repository.dart';

class GetLoginToken {
  final StoryRepository repository;

  const GetLoginToken(this.repository);

  /// Fetch log in token from the app cache if available.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<String?> execute() => repository.getLoginToken();
}
