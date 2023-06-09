import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_service.dart';
import '../data/cache/login_info_preferences.dart';
import '../data/cache/theme_mode_preferences.dart';
import '../data/repositories/story_repository_impl.dart';
import '../domain/repositories/story_repository.dart';
import '../domain/use_cases/do_login.dart';
import '../domain/use_cases/do_logout.dart';
import '../domain/use_cases/do_register.dart';
import '../domain/use_cases/get_login_token.dart';
import '../domain/use_cases/get_stories.dart';
import '../domain/use_cases/get_story_detail.dart';
import '../domain/use_cases/post_story.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/cameras_provider.dart';
import '../presentation/providers/picked_image_provider.dart';
import '../presentation/providers/stories_route_queries_provider.dart';
import '../presentation/providers/story_provider.dart';
import '../presentation/providers/theme_mode_provider.dart';

part 'initializers/provider_init.dart';
part 'initializers/services_init.dart';
part 'initializers/story_repository_init.dart';

/// Call [locator] to get desired dependencies.
///
/// `NOTE`: Call [init] before use the [locator].
///
/// ```dart
/// locator<AuthProvider>(); // return AuthProvider singleton object
/// ```
///
/// [locator] can adapt to its parent's generic type.
///
/// ```dart
/// ChangeNotifierProvider<AuthProvider>.value(
///   value: service_locator.locator(), // return AuthProvider singleton object
/// )
/// ```
final locator = GetIt.instance;

Future<void> init() async {
  _providerInit();
  await _servicesInit();
  _storyRepositoryInit();
}
