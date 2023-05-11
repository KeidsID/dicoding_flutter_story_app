import 'package:core/core.dart';

import '../../domain/repositories/story_repository.dart';
import '../api/api_service.dart';
import '../cache/login_token_preferences.dart';

class StoryRepositoryImpl implements StoryRepository {
  final ApiService apiService;
  final LoginTokenPreferences loginTokenPreferences;

  const StoryRepositoryImpl({
    required this.apiService,
    required this.loginTokenPreferences,
  });

  @override
  Future<String?> getLoginToken() async {
    try {
      final token = await loginTokenPreferences.getToken();

      return token;
    } catch (e) {
      throw HttpResponseException(
        500,
        message: 'Failed to fetch token in the cache',
      );
    }
  }

  @override
  Future<void> doLogin({
    required String email,
    required String password,
  }) async {
    final response = await apiService.login(
      email: email,
      password: password,
    );

    final token = response.loginResult.token;
    final isCached = await loginTokenPreferences.saveToken(token);

    if (!isCached) {
      throw HttpResponseException(
        500,
        message: 'Token is not cached. Please re-log in',
      );
    }
  }

  @override
  Future<void> doLogout() async {
    final isSuccess = await loginTokenPreferences.removeToken();

    if (!isSuccess) {
      throw throw HttpResponseException(
        500,
        message: 'Token is not removed. Please re-log out',
      );
    }
  }

  @override
  Future<void> doRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    await apiService.register(name: name, email: email, password: password);
  }
}
