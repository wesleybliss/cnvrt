import 'package:flutter/material.dart';

/// Shows a [SnackBar] from anywhere in the app, using a global context
/// Note: use this sparingly, as it's technically a hack
void globalSnackBar(String message) {
  // final log = Logger('globalSnackBar');

  /*if (Keys.navigatorKey.currentContext != null) {
    ScaffoldMessenger.of(Keys.navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
  } else {
    log.e('failed to show snackbar; navigatorKey was null');
  }*/
}

