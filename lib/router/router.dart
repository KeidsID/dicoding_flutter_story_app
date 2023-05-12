import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/pages/home_page.dart';
import '../presentation/providers/auth_provider.dart';
import '../service_locator/locator.dart';
import 'routes/auth_routes.dart';
import 'routes/story_routes.dart';

/// Router for the application.
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (_, __) => HttpErrorPages.client.notFound(),
  refreshListenable: locator<AuthProvider>(),
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();

    final isLoginPath = state.location == '/login';
    final isRegisterPath = state.location == '/register';

    if (authProvider.state == AuthProviderState.loggedOut) {
      return (isLoginPath || isRegisterPath) ? null : '/login';
    }

    if (authProvider.state == AuthProviderState.loggedIn) {
      return (isLoginPath || isRegisterPath) ? '/' : null;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
      routes: [...storyRoutes],
    ),
    ...authRoutes,
  ],
);
