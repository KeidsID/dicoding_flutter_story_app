import 'package:core/core.dart';
import 'package:dicoding_flutter_story_app/router/app_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/email_text_field.dart';
import '../../widgets/password_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 400.0,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text(appName, style: context.textTheme.headlineLarge),
                  const SizedBox(height: 16.0),

                  // Inputs
                  EmailTextField(controller: emailController),
                  PasswordTextField(
                    controller: passwordController,
                    isVisible: isPasswordVisible,
                    onIconPressed: () => setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    }),
                    onSubmitted: (value) => doLogin(),
                  ),
                  const SizedBox(height: 16.0),

                  // Actions
                  const SizedBox(height: 16.0),
                  Consumer<AuthProvider>(
                    builder: (context, prov, child) {
                      if (prov.state == AuthProviderState.loading) {
                        return child!;
                      }

                      return FilledButton(
                        onPressed: () => doLogin(),
                        child: const Text('Log in'),
                      );
                    },
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Need an account?'),
                      TextButton(
                        onPressed: () => context.go(AppRoutePaths.register),
                        child: const Text('Register'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doLogin() async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;
    final authProv = context.read<AuthProvider>();

    try {
      await authProv.login(
        email: emailController.text,
        password: passwordController.text,
      );
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(e.message ?? '${e.statusCode}: ${e.name}'),
      ));
    }
  }
}
