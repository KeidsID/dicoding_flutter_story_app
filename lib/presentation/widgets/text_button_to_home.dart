import 'package:dicoding_flutter_story_app/router/app_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [TextButton] which when pressed will navigate to the home page
/// (`/stories?page=1&size=10`).
class TextButtonToHome extends StatelessWidget {
  const TextButtonToHome({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(AppRoutePaths.stories()),
      child: const Text('Back to Home page'),
    );
  }
}