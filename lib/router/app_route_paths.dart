/// Paths that used to navigation.
///
/// ```dart
/// AppRoutePaths.login; // return '/login'
/// ```
abstract class AppRoutePaths {
  static const login = '/login';
  static const register = '/register';
  static const home = '/';
  static const addStory = '/stories';
  static String storyDetail(String id) => '/stories/$id';
}
