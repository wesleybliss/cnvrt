#!/bin/bash

flutter gen-l10n

dart run flutter_native_splash:create

dart run build_runner watch --delete-conflicting-outputs
