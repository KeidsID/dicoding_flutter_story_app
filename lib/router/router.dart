import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/pages/home_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_page.dart';
import '../presentation/providers/auth_provider.dart';
import '../service_locator/locator.dart';

final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (_, __) => HttpErrorPages.client.notFound(),
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
      redirect: (context, _) {
        final authProvider = context.read<AuthProvider>();

        if (authProvider.state == AuthProviderState.loggedOut) return '/login';

        return null;
      },
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
      redirect: (context, _) {
        final authProvider = context.read<AuthProvider>();

        if (authProvider.state == AuthProviderState.loggedIn) return '/';

        return null;
      },
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
      redirect: (context, _) {
        final authProvider = context.read<AuthProvider>();

        if (authProvider.state == AuthProviderState.loggedIn) return '/';

        return null;
      },
    ),
  ],
  refreshListenable: locator<AuthProvider>(),
);
