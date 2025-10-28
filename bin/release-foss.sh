#!/bin/bash

read -p "Did you update the version before running this? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    
    echo "Creating production release"
    
    flutter build apk --release --flavor foss --dart-define=FOSS_BUILD=true && \
        ls build/app/outputs/flutter-apk/app-foss-release.apk && \
        echo "FOSS release APK built successfully at build/app/outputs/flutter-apk/app-foss-release.apk" && \
        echo "TODO: automate F-Droid/etc. upload"
    
fi
