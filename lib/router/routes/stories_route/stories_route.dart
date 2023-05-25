import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../presentation/pages/camera/camera_not_found_page.dart';
import '../../../presentation/pages/camera/in_app_camera_page.dart';
import '../../../presentation/pages/home_page.dart';
import '../../../presentation/pages/post_story_page.dart';
import '../../../presentation/pages/story_detail_page.dart';
import '../../../presentation/providers/cameras_provider.dart';
import '../../../presentation/providers/stories_route_queries_provider.dart';
import '../../../presentation/widgets/back_to_home_button.dart';
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

    if (parsedPage == null || parsedSize == null) {
      return const HttpErrorPage(
        statusCode: 400,
        message: 'Invalid URL queries',
        child: BackToHomeButton(),
      );
    }

    final isPageLowerThanOne = (parsedPage) < 1;
    final isSizeLowerThanOne = (parsedSize) < 1;

    if (isPageLowerThanOne || isSizeLowerThanOne) {
      if (isPageLowerThanOne) {
        return const HttpErrorPage(
          statusCode: 400,
          message: 'The URL "page" query cannot be less than 1.',
          child: BackToHomeButton(),
        );
      }

      return const HttpErrorPage(
        statusCode: 400,
        message: 'The URL "size" query cannot be less than 1.',
        child: BackToHomeButton(),
      );
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
