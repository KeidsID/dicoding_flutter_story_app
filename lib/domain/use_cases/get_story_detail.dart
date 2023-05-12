import 'package:core/core.dart';

import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetStoryDetail {
  final StoryRepository repository;

  const GetStoryDetail(this.repository);

  /// Fetch the details of the requested story (based on the story id).
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<Story> execute({required String token, required String id}) {
    return repository.getStoryDetail(token: token, id: id);
  }
}
