import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/login_info.dart';
import '../../domain/use_cases/do_login.dart';
import '../../domain/use_cases/do_logout.dart';
import '../../domain/use_cases/do_register.dart';
import '../../domain/use_cases/get_login_token.dart';

enum AuthProviderState {
  /// Asynchronous process running.
  loading,
  loggedIn,
  loggedOut,

  /// On [HttpResponseException] thrown.
  serverFail,

  /// On [SocketException] thrown
  connectionFail,
}

class AuthProvider extends ChangeNotifier {
  final DoLogin _doLogin;
  final DoLogout _doLogout;
  final DoRegister _doRegister;
  final GetLoginToken _getLoginToken;

  AuthProvider({
    required DoLogin doLogin,
    required DoLogout doLogout,
    required DoRegister doRegister,
    required GetLoginToken getLoginToken,
  })  : _getLoginToken = getLoginToken,
        _doRegister = doRegister,
        _doLogout = doLogout,
        _doLogin = doLogin {
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

    _loginInfo = await _getLoginToken.execute();

    _setState = (_loginInfo == null)
        ? AuthProviderState.loggedOut
        : AuthProviderState.loggedIn;
  }

  /// Log in to Dicoding Story API, then update [state], [loginInfo], and
  /// [username] based on the results.
  ///
  /// Will throw an [Exception] if an error occurs.
  Future<void> login({required String email, required String password}) async {
    _setState = AuthProviderState.loading;

    try {
      await _doLogin.execute(email: email, password: password);

      await _fetchToken();
    } on HttpResponseException {
      _setState = AuthProviderState.serverFail;
      rethrow;
    } on SocketException {
      _setState = AuthProviderState.connectionFail;
      rethrow;
    }
  }

  /// Log out by deleting the login token in the cache, then update [state] and
  /// [loginInfo] based on the results.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server.
  Future<void> logout() async {
    _setState = AuthProviderState.loading;

    try {
      await _doLogout.execute();

      await _fetchToken();
    } on HttpResponseException {
      _setState = AuthProviderState.serverFail;
      rethrow;
    }
  }

  /// Register as new user to Dicoding Story API, then call [login] after the
  /// register process is complete.
  ///
  /// Will throw an [Exception] if an error occurs.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setState = AuthProviderState.loading;

    try {
      await _doRegister.execute(name: name, email: email, password: password);

      await login(email: email, password: password);
    } on HttpResponseException {
      _setState = AuthProviderState.serverFail;
      rethrow;
    } on SocketException {
      _setState = AuthProviderState.connectionFail;
      rethrow;
    }
  }
}
