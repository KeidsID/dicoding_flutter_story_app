import 'package:shared_preferences/shared_preferences.dart';

/// Service that handles login tokens in the app cache.
class LoginTokenPreferences {
  final SharedPreferences pref;
  static LoginTokenPreferences? instance;

  factory LoginTokenPreferences(SharedPreferences pref) =>
      instance ?? LoginTokenPreferences._init(pref);

  LoginTokenPreferences._init(this.pref) {
    instance = this;
  }

  static const _prefKey = 'auth.loginToken';

  Future<bool> saveToken(String token) => pref.setString(_prefKey, token);

  String? getToken() => pref.getString(_prefKey);

  Future<bool> removeToken() => pref.remove(_prefKey);
}
