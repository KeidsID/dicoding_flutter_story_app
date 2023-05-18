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
  ///
  /// Throw an [RangeError] if [page] or [size] are below `1`.
  static String stories({
    int page = 1,
    int size = 10,
    // LocationQuery location = LocationQuery.zero,
  }) {
    if (page < 1) {
      throw RangeError('The "page" parameter cannot be less than 1');
    }

    if (size < 1) {
      throw RangeError('The "size" parameter cannot be less than 1');
    }

    final url = ApiService.fetchStoriesUrlConfigs(
      page: page,
      size: size,
      // location: location,
    );

    final filteredPath = url.path.replaceAll('/v1', '');

    return (url.query != 'null') ? '$filteredPath?${url.query}' : filteredPath;
  }

  static const postStory = '/stories/post';
  static const camera = '/stories/camera';
  static String storyDetail(String id) => '/stories/view/$id';
}
