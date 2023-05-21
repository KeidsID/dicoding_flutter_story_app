import 'package:camera/camera.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/apps/global_data.dart' as global_data;
import '../../../presentation/pages/camera_not_found_page.dart';
import '../../../presentation/pages/home_page.dart';
import '../../../presentation/pages/in_app_camera_page.dart';
import '../../../presentation/pages/post_story_page.dart';
import '../../../presentation/pages/story_detail_page.dart';
import '../../../presentation/providers/stories_route_queries_provider.dart';
import '../../../presentation/widgets/text_button_to_home.dart';
import '../../app_route_paths.dart';

part 'routes/camera_route.dart';
part 'routes/post_story_route.dart';
part 'routes/story_detail_route.dart';

final storiesRoute = GoRoute(
  path: '/stories',
  builder: (context, state) {
    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();

    final queries = state.queryParameters;

    // To support back button dispatcher
    final page = queries['page'] ?? storiesRouteQueries.page.toString();
    final size = queries['size'] ?? storiesRouteQueries.size.toString();

    final parsedPage = int.tryParse(page);
    final parsedSize = int.tryParse(size);
    // TODO: Support it on upcoming version
    // final location = queries['location'];

    // To prevent rendering error pages for "/stories" sub-routes
    // ("/stories/:id, etc).
    if (state.location == '/stories') {
      if (parsedPage == null || parsedSize == null) {
        return const HttpErrorPage(
          statusCode: 400,
          message: 'Invalid URL queries',
          child: TextButtonToHome(),
        );
      }

      final isPageLowerThanOne = (parsedPage) < 1;
      final isSizeLowerThanOne = (parsedSize) < 1;

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

      return HomePage(page: parsedPage, size: parsedSize);
    }

    return HomePage(page: parsedPage, size: parsedSize);
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
