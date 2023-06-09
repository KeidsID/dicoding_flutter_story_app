import 'package:dicoding_flutter_story_app/domain/entities/login_info.dart';

import '../repositories/story_repository.dart';

class GetLoginToken {
  final StoryRepository repository;

  const GetLoginToken(this.repository);

  /// Fetch log in token from the app cache if available.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server,
  /// otherwise it will throw another [Exception] (such as [SocketException]) if
  /// an internal error occurs.
  Future<LoginInfo?> execute() => repository.getLoginInfo();
}
