# Task

This app will be built and distributed through official app stores Google Play and
Apple App Store, but also various Free and Open Source Software (FOSS) app stores
like F-Droid. To facilitate this, we need to set up the necessary build configurations
that exclude proprietary libraries like Firebase.

# Steps
- Review the current build configuration files (e.g., `build.gradle`, `Podfile`, etc.).
- Identify and isolate any proprietary dependencies (e.g., Firebase, Google Play Services).
- Create separate build flavors or targets for FOSS builds that exclude these dependencies.
- Update the build scripts to handle the new FOSS build configurations.
- Test the FOSS build configurations to ensure the app functions correctly without the proprietary libraries.
- Document the build process for FOSS builds in the project README or a dedicated documentation file.
- Run all tests and Dart lint to ensure no issues.
- Commit the changes with a descriptive message.
