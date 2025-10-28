import 'package:cnvrt/config/flavor.dart';
import 'package:cnvrt/utils/logger.dart';
import 'package:cnvrt/utils/network_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart' if (dart.library.js) 'firebase_stub.dart';

final _log = Logger('CrashlyticsUtils');

/// Records an error to Firebase Crashlytics only if it's not a connectivity error.
/// Connectivity errors are expected and user-controllable, so we don't report them.
Future<void> recordNonConnectivityError(
  Object error,
  StackTrace stackTrace, {
  bool fatal = false,
}) async {
  // Skip for FOSS builds
  if (!FlavorConfig.isFirebaseEnabled) {
    _log.d('Skipping Crashlytics report for FOSS build');
    return;
  }
  
  // Don't report connectivity errors to Crashlytics
  if (isConnectivityError(error)) {
    _log.d('Skipping Crashlytics report for connectivity error: ${toStringSafe(error, maxLength: 200)}');
    return;
  }

  _log.d('Recording error to Crashlytics: ${toStringSafe(error, maxLength: 200)}');
  
  await FirebaseCrashlytics.instance.recordError(
    error,
    stackTrace,
    fatal: fatal,
  );
}
