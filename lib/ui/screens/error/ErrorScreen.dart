
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.message = 'Unknown error'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(message),
      );
  }
}
