import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
    const textFieldMinWidth = 400.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register', style: context.textTheme.headlineLarge),
            const SizedBox(height: 16.0),
            // Name field
            SizedBox(
              width: textFieldMinWidth,
              child: TextField(
                decoration: const InputDecoration(
                  label: Text('Name'),
                  hintText: 'Fulan Dicoding',
                ),
                controller: nameController,
              ),
            ),
            // Email field
            SizedBox(
              width: textFieldMinWidth,
              child: TextField(
                decoration: const InputDecoration(
                  label: Text('Email'),
                  hintText: 'fulanBinFulan@dicoding.com',
                ),
                controller: emailController,
              ),
            ),
            // Password field
            SizedBox(
              width: textFieldMinWidth,
              child: TextField(
                decoration: InputDecoration(
                  label: const Text('Password'),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    }),
                    icon: Icon(
                      (isPasswordVisible)
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                controller: passwordController,
                obscureText: !isPasswordVisible,
              ),
            ),
            const SizedBox(height: 16.0),
            FilledButton(onPressed: () {}, child: const Text('Register')),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
