part of '../stories_route.dart';

final _storyDetailRoute = GoRoute(
  path: 'view/:id',
  builder: (context, state) {
    final storyId = state.pathParameters['id'];

    if (storyId == null) {
      return const HttpErrorPage(statusCode: 400, child: TextButtonToHome());
    }

    return StoryDetailPage(storyId);
  },
);
