part of '../stories_route.dart';

final _postStoryRoute = GoRoute(
  path: 'post',
  builder: (_, __) => HttpErrorPages.client.notFound(),
);
