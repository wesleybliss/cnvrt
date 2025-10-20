import 'package:cnvrt/utils/crashlytics_utils.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:cnvrt/l10n/app_localizations.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key, this.error, this.stackTrace, this.onRetry});

  final Exception? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

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
    if (widget.error == null) {
      log.d('[Crashlytics Test] No error to report');
      return;
    }

    // Use utility that filters out connectivity errors
    await recordNonConnectivityError(
      widget.error!,
      widget.stackTrace ?? StackTrace.current,
      fatal: false,
    );

    log.d('[Crashlytics Test] Error recorded successfully (if not connectivity)');
    log.d('[Crashlytics Test] Restart app to upload to Firebase');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.error?.toString() ?? 'An unknown error occurred.',
              textAlign: TextAlign.center,
            ),
            if (widget.onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: widget.onRetry,
                child: Text(
                  AppLocalizations.of(context)?.retry.toUpperCase() ?? 'RETRY',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
