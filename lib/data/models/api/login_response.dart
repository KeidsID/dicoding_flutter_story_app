import 'dart:convert';

/// Object model for `/login` endpoint response from API.
class LoginResponse {
  final bool error;
  final String message;
  final LoginResult loginResult;

  const LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'loginResult': loginResult.toMap(),
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      error: map['error'] as bool,
      message: map['message'] as String,
      loginResult:
          LoginResult.fromMap(map['loginResult'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  const LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'token': token,
    };
  }

  factory LoginResult.fromMap(Map<String, dynamic> map) {
    return LoginResult(
      userId: map['userId'] as String,
      name: map['name'] as String,
      token: map['token'] as String,
    );
  }
}
