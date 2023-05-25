import 'package:shared_preferences/shared_preferences.dart';

import '../models/cache/login_info_model.dart';

/// Service that handles [LoginInfoModel] in the app cache.
class LoginInfoPreferences {
  final SharedPreferences sharedPreferences;

  const LoginInfoPreferences(this.sharedPreferences);

  static const _prefKey = 'auth';
  static const _loginInfoKey = '$_prefKey.loginInfo';

  Future<bool> saveLoginInfo(LoginInfoModel loginInfo) {
    final jsonStr = loginInfo.toJson();

    return sharedPreferences.setString(_loginInfoKey, jsonStr);
  }

  Future<LoginInfoModel?> getLoginInfo() async {
    await sharedPreferences.reload();

    final jsonStr = sharedPreferences.getString(_loginInfoKey);

    return (jsonStr != null) ? LoginInfoModel.fromJson(jsonStr) : null;
  }

  Future<bool> removeLoginInfo() => sharedPreferences.remove(_loginInfoKey);
}
