abstract class StoryRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
  Future<String> login({
    required String email,
    required String password,
  });
  String? getLoginToken();
  Future<bool> logout();
}
