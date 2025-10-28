#!/bin/bash

read -p "Did you update the version before running this? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    
    echo "Creating production release"
    
    flutter build apk --release --flavor standard && \
        firebase appdistribution:distribute \
            build/app/outputs/flutter-apk/app-release.apk \
            --app '1:1021931476908:android:0ef35750044f283fef4c09' \
            --groups 'alpha-testers'
    
fi
