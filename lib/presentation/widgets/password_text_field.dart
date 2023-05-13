import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  /// Create a simple [TextField] which is suitable for password input.
  ///
  /// Only need the [isVisible] parameter to determine the visibility of the
  /// text, and use [onIconPressed] to control the state when the eye icon in
  /// [TextField] is pressed.
  const PasswordTextField({
    super.key,
    this.controller,
    this.isVisible = true,
    this.onIconPressed,
    this.onSubmitted,
  });

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Property that determines whether text should be visible or not
  final bool isVisible;

  /// The callback that is called when the eye icon (as shown below) is tapped
  /// or otherwise activated.
  ///
  /// <i class="material-icons md-36">visibility</i> &#x2014;
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onIconPressed;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        label: const Text('Password'),
        suffixIcon: IconButton(
          onPressed: onIconPressed,
          icon: Icon(
            (isVisible) ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
