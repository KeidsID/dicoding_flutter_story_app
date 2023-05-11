import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

/// Add these routes in `GoRoute(path: '/')`.
final storyRoutes = [
  // Stories list path are root url ("/" a.k.a HomePage).

  // Story detail
  GoRoute(
    path: 'stories/:id',
    builder: (_, __) => HttpErrorPages.client.notFound(),
  ),
  // Add story
  GoRoute(
    path: 'stories',
    builder: (_, __) => HttpErrorPages.client.notFound(),
  ),
];
