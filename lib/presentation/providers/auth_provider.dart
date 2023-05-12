import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/login_info.dart';
import '../../domain/use_cases/do_login.dart';
import '../../domain/use_cases/do_logout.dart';
import '../../domain/use_cases/do_register.dart';
import '../../domain/use_cases/get_login_token.dart';

enum AuthProviderState { loading, loggedIn, loggedOut, error }

class AuthProvider extends ChangeNotifier {
  final DoLogin doLogin;
  final DoLogout doLogout;
  final DoRegister doRegister;
  final GetLoginToken getLoginToken;

  AuthProvider({
    required this.doLogin,
    required this.doLogout,
    required this.doRegister,
    required this.getLoginToken,
  }) {
    _fetchToken();
  }

  AuthProviderState _state = AuthProviderState.loggedOut;
  LoginInfo? _loginInfo;

  AuthProviderState get state => _state;
  LoginInfo? get loginInfo => _loginInfo;

  set _setState(AuthProviderState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> _fetchToken() async {
    _setState = AuthProviderState.loading;

    _loginInfo = await getLoginToken.execute();

    _setState = (_loginInfo == null)
        ? AuthProviderState.loggedOut
        : AuthProviderState.loggedIn;
  }

  /// Log in to Dicoding Story API, then update [state], [loginInfo], and
  /// [username] based on the results.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> login({required String email, required String password}) async {
    _setState = AuthProviderState.loading;

    try {
      await doLogin.execute(email: email, password: password);

      await _fetchToken();
    } catch (e) {
      _setState = AuthProviderState.error;
      rethrow;
    }
  }

  /// Log out by deleting the login token in the cache, then update [state] and
  /// [loginInfo] based on the results.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> logout() async {
    _setState = AuthProviderState.loading;

    try {
      await doLogout.execute();

      await _fetchToken();
    } catch (e) {
      _setState = AuthProviderState.error;
      rethrow;
    }
  }

  /// Register as new user to Dicoding Story API, then call [login] after the
  /// register process is complete.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setState = AuthProviderState.loading;

    try {
      await doRegister.execute(name: name, email: email, password: password);

      await login(email: email, password: password);
    } catch (e) {
      _setState = AuthProviderState.error;
      rethrow;
    }
  }
}
