import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/pages/in_app_camera_page.dart';
import '../../../presentation/pages/home_page.dart';
import '../../../presentation/pages/post_story_page.dart';
import '../../../presentation/pages/story_detail_page.dart';
import '../../../presentation/widgets/text_button_to_home.dart';
import '../../../data/apps/global_data.dart' as global_data;
import '../../app_route_paths.dart';

part 'routes/camera_route.dart';
part 'routes/post_story_route.dart';
part 'routes/story_detail_route.dart';

final storiesRoute = GoRoute(
  path: '/stories',
  builder: (_, state) {
    final queries = state.queryParameters;

    final page = int.tryParse(queries['page'] ?? 'null');
    final size = int.tryParse(queries['size'] ?? 'null');
    // TODO: Support it on upcoming version
    // final location = queries['location'];

    // To prevent rendering error pages for "/stories" sub-routes
    // ("/stories/:id, etc).
    if (state.location == '/stories') {
      if (page == null || size == null) {
        return const HttpErrorPage(
          statusCode: 400,
          message: 'Invalid URL queries',
          child: TextButtonToHome(),
        );
      }

      final isPageLowerThanOne = (page) < 1;
      final isSizeLowerThanOne = (size) < 1;

      if (isPageLowerThanOne || isSizeLowerThanOne) {
        if (isPageLowerThanOne) {
          return const HttpErrorPage(
            statusCode: 400,
            message: 'The URL "page" query cannot be less than 1.',
            child: TextButtonToHome(),
          );
        }

        return const HttpErrorPage(
          statusCode: 400,
          message: 'The URL "size" query cannot be less than 1.',
          child: TextButtonToHome(),
        );
      }

      return HomePage(page: page, size: size);
    }

    return HomePage(page: page, size: size);
  },
  redirect: (context, state) {
    if (state.location == '/stories') return AppRoutePaths.stories();

    return null;
  },
  routes: [
    _cameraRoute,
    _storyDetailRoute,
    _postStoryRoute,
  ],
);
