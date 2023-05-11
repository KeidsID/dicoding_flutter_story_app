import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/email_text_field.dart';
import '../widgets/password_text_field.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraint) => (constraint.maxHeight <= 400)
              ? Center(child: SingleChildScrollView(child: mainContent()))
              : mainContent(),
        ),
      ),
    );
  }

  Widget mainContent() {
    const textFieldMinWidth = 400.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Register Form', style: context.textTheme.headlineLarge),
        const SizedBox(height: 16.0),

        // Name field
        SizedBox(
          width: textFieldMinWidth,
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              label: Text('Name'),
              hintText: 'John Doe from Dicoding',
            ),
          ),
        ),

        // Email field
        SizedBox(
          width: textFieldMinWidth,
          child: EmailTextField(controller: emailController),
        ),

        // Password field
        SizedBox(
          width: textFieldMinWidth,
          child: PasswordTextField(
            controller: passwordController,
            isVisible: isPasswordVisible,
            onIconPressed: () => setState(() {
              isPasswordVisible = !isPasswordVisible;
            }),
          ),
        ),
        const SizedBox(height: 16.0),

        // Actions
        Consumer<AuthProvider>(
          builder: (context, prov, _) {
            if (prov.state == AuthProviderState.loading) {
              return const CircularProgressIndicator();
            }

            return FilledButton(
              onPressed: () async {
                final scaffoldMessenger = context.scaffoldMessenger;

                try {
                  await prov.register(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } on HttpResponseException catch (e) {
                  prov.state = AuthProviderState.error;
                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text('${e.statusCode}: ${e.message}'),
                  ));
                }
              },
              child: const Text('Register'),
            );
          },
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Login'),
            ),
          ],
        )
      ],
    );
  }
}
