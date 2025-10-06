# Task

Enable Linux support for Firebase, or disable it if running on
an unsupported platform.

Currently, I receive this error when trying to run Firebase on Linux:

```
[ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: Unsupported operation: DefaultFirebaseOptions have not been configured for linux - you can reconfigure this by running the FlutterFire CLI again.
#0      DefaultFirebaseOptions.currentPlatform (package:cnvrt/firebase_options.dart:32:9)
#1      initializeFirebase (package:cnvrt/utils/firebase.dart:18:37)
#2      main (package:cnvrt/main.dart:15:9)
#3      _runMain.<anonymous closure> (dart:ui/hooks.dart:320:23)
#4      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:314:19)
#5      _RawReceivePort._handleMessage (dart:isolate-patch/isolate_patch.dart:193:12)
```
