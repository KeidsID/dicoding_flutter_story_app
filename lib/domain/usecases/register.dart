import 'package:core/core.dart';

import '../repositories/story_repository.dart';

class Register {
  final StoryRepository repository;

  const Register(this.repository);

  /// Register as new user to Dicoding Story API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> execute({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(name: name, email: email, password: password);
  }
}
