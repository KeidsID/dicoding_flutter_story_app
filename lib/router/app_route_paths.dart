import '../data/api/api_service.dart';

/// Paths that used to navigation.
///
/// ```dart
/// AppRoutePaths.login; // return '/login'
/// ```
abstract class AppRoutePaths {
  static const login = '/login';
  static const register = '/register';

  /// return "/stories{with queries if specified}".
  ///
  /// Example: "/stories?page=1&size=10"
  static String stories({
    int? page,
    int? size,
    LocationQuery? location,
  }) {
    final url = ApiService.fetchStoriesUrlConfigs(
      page: page,
      size: size,
      location: location,
    );

    final filteredPath = url.path.replaceAll('/v1', '');

    return (url.query != 'null') ? '$filteredPath?${url.query}' : filteredPath;
  }

  static const postStory = '/stories/post';
  static String storyDetail(String id) => '/stories/$id';
}
