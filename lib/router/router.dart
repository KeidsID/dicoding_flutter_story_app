import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/pages/home_page.dart';
import '../presentation/providers/auth_provider.dart';
import '../service_locator/locator.dart';
import 'app_route_paths.dart';
import 'routes/auth_routes.dart';
import 'routes/story_routes.dart';

/// Router for the application.
final router = GoRouter(
  initialLocation: AppRoutePaths.stories(),
  errorBuilder: (_, state) {
    debugPrint('${state.error}');
    return HttpErrorPages.client.notFound();
  },
  refreshListenable: locator<AuthProvider>(),
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();

    debugPrint('Current route: ${state.location}');

    final isLoginPath = state.location == AppRoutePaths.login;
    final isRegisterPath = state.location == AppRoutePaths.register;

    if (authProvider.state == AuthProviderState.loggedOut) {
      return (isLoginPath || isRegisterPath) ? null : AppRoutePaths.login;
    }

    if (authProvider.state == AuthProviderState.loggedIn) {
      return (isLoginPath || isRegisterPath) ? AppRoutePaths.stories() : null;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/stories',
      builder: (_, state) {
        final queries = state.queryParameters;

        final page = int.tryParse(queries['page'] ?? 'null');
        final size = int.tryParse(queries['size'] ?? 'null');
        // TODO: Support it on upcoming version
        // final location = queries['location'];

        return HomePage(page: page, size: size);
      },
      routes: [...storyRoutes],
    ),
    ...authRoutes,
  ],
);
