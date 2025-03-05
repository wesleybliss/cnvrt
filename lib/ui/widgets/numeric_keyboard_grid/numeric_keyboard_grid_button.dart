import 'package:flutter/material.dart';

class NumericKeyboardGridButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  const NumericKeyboardGridButton({super.key, required this.label, required this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        minimumSize: const Size(10, 10),
        maximumSize: const Size(10, 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
