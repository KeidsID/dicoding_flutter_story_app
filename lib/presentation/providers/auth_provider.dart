import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
  String? _loginToken;

  String? get loginToken => _loginToken;

  AuthProviderState get state => _state;
  set state(AuthProviderState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> _fetchToken() async {
    state = AuthProviderState.loading;

    _loginToken = await getLoginToken.execute();

    state = (_loginToken == null)
        ? AuthProviderState.loggedOut
        : AuthProviderState.loggedIn;
  }

  /// Log in to Dicoding Story API, then update [state] and [loginToken] based
  /// on the results.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> login({required String email, required String password}) async {
    state = AuthProviderState.loading;

    await doLogin.execute(email: email, password: password);

    await _fetchToken();
  }

  /// Log out by deleting the login token in the cache, then update [state] and
  /// [loginToken] based on the results.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> logout() async {
    state = AuthProviderState.loading;

    await doLogout.execute();

    await _fetchToken();
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
    state = AuthProviderState.loading;

    await doRegister.execute(name: name, email: email, password: password);

    await login(email: email, password: password);
  }
}
