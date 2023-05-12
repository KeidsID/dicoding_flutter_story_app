import '../repositories/story_repository.dart';

class DoLogin {
  final StoryRepository repository;

  const DoLogin(this.repository);

  /// Log in to Dicoding Story API. The log in token will be cached as well.
  ///
  /// Return username.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<String> execute({
    required String email,
    required String password,
  }) {
    return repository.doLogin(email: email, password: password);
  }
}
