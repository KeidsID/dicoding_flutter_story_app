import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../presentation/providers/stories_route_queries_provider.dart';
import '../app_route_paths.dart';

/// Navigate to "/stories" route with queries provided by
/// [StoriesRouteQueriesProvider].
///
/// If [isQueriesProvider] is false, then navigate to Home page
/// ("/stories?page=1&size=10").
///
/// If called on the "/stories" route, this function only updates the router's
/// route info and does not rebuild the page.
void navigateToStoriesPage(BuildContext context,
    {bool isQueriesProvided = true}) {
  if (isQueriesProvided) {
    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();

    context.go(AppRoutePaths.stories(
      page: storiesRouteQueries.page,
      size: storiesRouteQueries.size,
    ));
    return;
  }

  context.go(AppRoutePaths.stories());
}
