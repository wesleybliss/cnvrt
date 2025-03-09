import 'package:flutter/material.dart';

class UnknownError extends StatelessWidget {
  final String message;

  const UnknownError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: Text('Unknown error: $message')),
    ]);
  }
}
