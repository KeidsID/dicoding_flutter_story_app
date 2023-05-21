import 'package:flutter/material.dart';

import '../../utils/navigate_to_home.dart';

/// [TextButton] which when pressed will navigate to the home page
/// (`/stories?page=1&size=10`).
class TextButtonToHome extends StatelessWidget {
  const TextButtonToHome({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => navigateToHome(context, isQueriesProvided: false),
      child: const Text('Back to Home page'),
    );
  }
}
