import 'package:flutter/material.dart';

import '../../router/utils/navigate_to_stories_page.dart';

class AppAlertDialog extends StatelessWidget {
  /// Creates an alert dialog with default action.
  ///
  /// The default action can be removed by specify [isDefaultActionIncluded].
  const AppAlertDialog({
    super.key,
    this.title,
    this.content,
    this.isDefaultActionIncluded = true,
    this.actions,
  });

  /// The (optional) title of the dialog is displayed in a large font at the
  /// top of the dialog, below the (optional) [icon].
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  ///
  /// Typically this is a [SingleChildScrollView] that contains the dialog's
  /// message. As noted in the [AlertDialog] documentation, it's important to
  /// use a [SingleChildScrollView] if there's any risk that the content will
  /// not fit.
  final Widget? content;

  /// Determines whether the default action is included or not.
  final bool isDefaultActionIncluded;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog with an [OverflowBar].
  ///
  /// Typically this is a list of [TextButton] widgets. It is recommended to
  /// set the [Text.textAlign] to [TextAlign.end] for the [Text] within the
  /// [TextButton], so that buttons whose labels wrap to an extra line align
  /// with the overall [OverflowBar]'s alignment within the dialog.
  ///
  /// If the [title] is not null but the [content] is null, then an extra 20
  /// pixels of padding is added above the [OverflowBar] to separate the [title]
  ///  from the [actions].
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final otherActions = actions ?? [];

    return AlertDialog(
      title: title,
      content: content,
      actions: isDefaultActionIncluded
          ? [
              TextButton(
                onPressed: () => navigateToStoriesPage(
                  context,
                  isQueriesProvided: false,
                ),
                child: const Text('Back to home', textAlign: TextAlign.end),
              ),
              ...otherActions,
            ]
          : otherActions,
    );
  }
}
