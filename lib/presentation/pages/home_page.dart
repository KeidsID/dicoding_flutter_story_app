import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Home Page'),
            FilledButton(
              onPressed: () {},
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
