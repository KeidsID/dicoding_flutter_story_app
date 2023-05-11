import 'package:go_router/go_router.dart';

import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/register_page.dart';

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
