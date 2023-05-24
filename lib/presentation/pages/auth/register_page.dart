import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../router/app_route_paths.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/email_text_field.dart';
import '../../widgets/password_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // Page max width
            width: 400.0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text('Register Form', style: context.textTheme.headlineLarge),
                  const SizedBox(height: 16.0),

                  // Inputs
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      hintText: 'John Doe from Dicoding',
                    ),
                  ),
                  EmailTextField(controller: emailController),
                  PasswordTextField(
                    controller: passwordController,
                    isVisible: isPasswordVisible,
                    onIconPressed: () => setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    }),
                    onSubmitted: (value) => doRegister(),
                  ),
                  const SizedBox(height: 32.0),

                  // Actions
                  Consumer<AuthProvider>(
                    builder: (context, authProv, child) {
                      if (authProv.state == AuthProviderState.loading) {
                        return child!;
                      }

                      return FilledButton(
                        onPressed: () => doRegister(),
                        child: const Text('Register'),
                      );
                    },
                    child: const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () => context.go(AppRoutePaths.login),
                        child: const Text('Log in'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doRegister() async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;
    final authProv = context.read<AuthProvider>();

    try {
      await authProv.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(e.message ?? '${e.statusCode}: ${e.name}'),
      ));
    } catch (e) {
      showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }
}
