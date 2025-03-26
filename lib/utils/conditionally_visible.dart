import 'package:flutter/material.dart';

class ConditionallyVisible extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  const ConditionallyVisible({super.key, required this.child, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible, // Control visibility here
      maintainSize: true, // Maintain size in layout
      maintainAnimation: true,
      maintainState: true,
      child: child,
    );
  }
}
