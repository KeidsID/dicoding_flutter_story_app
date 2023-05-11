import 'package:shared_preferences/shared_preferences.dart';

/// Service that handles login tokens in the app cache.
class LoginTokenPreferences {
  final SharedPreferences sharedPreferences;

  const LoginTokenPreferences(this.sharedPreferences);

  static const _prefKey = 'auth.loginToken';

  Future<bool> saveToken(String token) {
    return sharedPreferences.setString(_prefKey, token);
  }

  Future<String?> getToken() async {
    await sharedPreferences.reload();

    return sharedPreferences.getString(_prefKey);
  }

  Future<bool> removeToken() => sharedPreferences.remove(_prefKey);
}
