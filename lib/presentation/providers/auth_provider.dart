import 'package:flutter/material.dart';

enum AuthProviderState { loading, loggedIn, loggedOut }

class AuthProvider extends ChangeNotifier {
  AuthProvider();

  AuthProviderState _state = AuthProviderState.loggedOut;

  AuthProviderState get state => _state;
  set state(AuthProviderState value) {
    _state = value;
    notifyListeners();
  }
}
