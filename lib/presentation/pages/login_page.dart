import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
    const textFieldMinWidth = 400.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(appName, style: context.textTheme.headlineLarge),
            const SizedBox(height: 16.0),
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
            FilledButton(onPressed: () {}, child: const Text('Login')),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Need an account?'),
                TextButton(
                  onPressed: () {},
                  child: const Text('Register'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
