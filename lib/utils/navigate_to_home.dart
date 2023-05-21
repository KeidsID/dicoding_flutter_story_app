import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/providers/stories_route_queries_provider.dart';
import '../router/app_route_paths.dart';

void navigateToHome(BuildContext context, {bool isQueriesProvided = true}) {
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
