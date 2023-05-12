import 'package:core/core.dart';

import '../../data/api/api_service.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetStories {
  final StoryRepository repository;

  const GetStories(this.repository);

  /// Fetch stories from the API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<List<Story>> execute({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  }) {
    return repository.getStories(
      token: token,
      page: page,
      size: size,
      location: location,
    );
  }
}
