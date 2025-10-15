import 'package:cnvrt/utils/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key, this.error, this.stackTrace});

  final Exception? error;
  final StackTrace? stackTrace;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final log = Logger('ErrorScreen');
  
  @override
  void initState() {
    super.initState();
    sendCrashReport();
  }

  Future<void> sendCrashReport() async {
    final isEnabled =
        FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
    log.d('[Crashlytics Test] Crashlytics enabled: $isEnabled');

    if (widget.error == null) {
      log.d('[Crashlytics Test] No error to report');
      return;
    }

    await FirebaseCrashlytics.instance.recordError(
      widget.error,
      widget.stackTrace,
      fatal: false,
    );

    log.d('[Crashlytics Test] Error recorded successfully');
    log.d('[Crashlytics Test] Restart app to upload to Firebase');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.error?.toString() ?? 'An unknown error occurred.'),
    );
  }
}
