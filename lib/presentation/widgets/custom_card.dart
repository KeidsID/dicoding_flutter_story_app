import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, this.onTap, this.child});

  final GestureTapCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
