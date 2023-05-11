import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  /// Creates a [TextField] which is suitable as email input.
  const EmailTextField({super.key, this.controller});

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        label: Text('Email'),
        hintText: 'johndoe@dicoding.com',
      ),
    );
  }
}
