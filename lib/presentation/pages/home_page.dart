import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            const SizedBox(height: 16.0),
            FilledButton(
              onPressed: () => context.read<AuthProvider>().logout(),
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
