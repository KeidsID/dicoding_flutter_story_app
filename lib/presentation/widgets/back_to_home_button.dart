import 'package:flutter/material.dart';

import '../../router/utils/navigate_to_stories_page.dart';

/// Button that when pressed will navigate to the home route.
/// (`/stories?page=1&size=10`).
class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () => navigateToStoriesPage(context, isQueriesProvided: false),
      child: const Text('Back to home'),
    );
  }
}
