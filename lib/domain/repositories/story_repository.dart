abstract class StoryRepository {
  Future<void> doRegister({
    required String name,
    required String email,
    required String password,
  });
  Future<void> doLogin({
    required String email,
    required String password,
  });
  String? getLoginToken();
  Future<void> doLogout();
}
