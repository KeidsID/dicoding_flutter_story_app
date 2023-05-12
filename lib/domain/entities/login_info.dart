class LoginInfo {
  const LoginInfo({
    required this.name,
    required this.token,
  });

  /// Logged username.
  final String name;

  /// Token for fetching stories from API.
  final String token;
}
