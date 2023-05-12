import 'package:core/core.dart';

import '../repositories/story_repository.dart';

class PostStory {
  final StoryRepository repository;

  const PostStory(this.repository);

  /// Posting story to the API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> execute({
    required String token,
    required String description,
    required List<int> photo,
    double? lat,
    double? lon,
  }) {
    return repository.postStory(
      token: token,
      description: description,
      photo: photo,
      lat: lat,
      lon: lon,
    );
  }
}
