import '../repositories/story_repository.dart';

class Login {
  final StoryRepository repository;

  const Login(this.repository);

  /// Log in to Dicoding Story API.
  ///
  /// Returns a token that can be used to access stories in the API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<String> execute({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
