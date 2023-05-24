import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../dependencies/locator.dart' as dependencies;
import '../presentation/providers/auth_provider.dart';
import '../presentation/widgets/back_to_home_button.dart';
import 'app_route_paths.dart';
import 'routes/auth_routes.dart';
import 'routes/stories_route/stories_route.dart';

/// Router for the application.
final router = GoRouter(
  initialLocation: AppRoutePaths.stories(),
  refreshListenable: dependencies.locator<AuthProvider>(),
  routerNeglect: true,
  errorBuilder: (_, state) {
    debugPrint('${state.error}');
    return const HttpErrorPage(statusCode: 404, child: BackToHomeButton());
  },
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();

    debugPrint('Current route location: ${state.location}');

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
    storiesRoute,
    ...authRoutes,
  ],
);
