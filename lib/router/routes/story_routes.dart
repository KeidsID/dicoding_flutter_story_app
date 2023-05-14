import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../presentation/pages/story_detail_page.dart';
import '../../presentation/providers/story_provider.dart';

/// Add these routes in `GoRoute(path: '/stories')`.
final storyRoutes = [
  // Story detail
  GoRoute(
    path: ':id',
    builder: (context, state) {
      final storyId = state.pathParameters['id'];

      final notFoundPage = HttpErrorPages.client.notFound(
        child: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Go back'),
        ),
      );

      if (storyId == null) return notFoundPage;

      final stories = context.read<StoryProvider>().stories;

      if (!(stories.any((e) => e.id == storyId))) return notFoundPage;

      return StoryDetailPage(storyId);
    },
  ),
  // Post story
  GoRoute(
    path: 'post',
    builder: (_, __) => HttpErrorPages.client.notFound(),
  ),
];
