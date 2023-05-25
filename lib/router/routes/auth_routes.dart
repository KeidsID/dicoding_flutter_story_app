import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';

final authRoutes = [
  GoRoute(
    path: '/login',
    builder: (_, __) => const LoginPage(),
  ),
  GoRoute(
    path: '/register',
    builder: (_, __) => const RegisterPage(),
  ),
];
