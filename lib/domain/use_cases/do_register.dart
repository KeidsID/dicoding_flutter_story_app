import 'package:core/core.dart';

import '../repositories/story_repository.dart';

class DoRegister {
  final StoryRepository repository;

  const DoRegister(this.repository);

  /// Register as new user to Dicoding Story API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server,
  /// otherwise it will throw another [Exception] (such as [SocketException]) if
  /// an internal error occurs.
  Future<void> execute({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.doRegister(name: name, email: email, password: password);
  }
}
