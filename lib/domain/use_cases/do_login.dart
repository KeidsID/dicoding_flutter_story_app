import '../repositories/story_repository.dart';

class DoLogin {
  final StoryRepository repository;

  const DoLogin(this.repository);

  /// Log in to Dicoding Story API. The log in token will be cached as well.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server,
  /// otherwise it will throw another [Exception] (such as [SocketException]) if
  /// an internal error occurs.
  Future<void> execute({
    required String email,
    required String password,
  }) {
    return repository.doLogin(email: email, password: password);
  }
}
