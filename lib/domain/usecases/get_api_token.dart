import '../repositories/story_repository.dart';

class GetApiToken {
  final StoryRepository repository;

  const GetApiToken(this.repository);

  /// Fetch log in token from the cache if available.
  String? execute() => repository.getLoginToken();
}
