#!/bin/bash

# Note: the cut delimiter is actually a tab here
device=$(adb devices | grep '._tcp' | cut -d '	' -f1)

if [[ -z "$device" ]]; then
    echo "No wireless device connected"
    echo "Result: $device"
    exit 1
fi

echo "Installing to: $device"

flutter build apk --release && \
    adb -s "$device" install build/app/outputs/flutter-apk/app-release.apk
