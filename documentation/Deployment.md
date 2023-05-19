# Deployment

This document describes the necessary steps to deploy signal to both Stage (Crashlytics) and Production (TestFlight/App Store).

## Stage Deployment

1. Make sure the `develop` branch is in the state you want to deploy.
2. Build the `portkey-stage` target to `device` and confirm it builds successfully.
3. Create a pull request on GitHub using `stage` as base and `develop` as compare.
4. Merge the pull request into `stage`. This will trigger a CircleCI build that will be pushed to Crashlytics.
5. When you get the new Crashlytics build e-mail, install and confirm it works fine.
6. Send the build to **Airteam** or any other recipients you want.

## Production Deployment

1. Make sure the `stage` branch is in the state you want to deploy.
2. Make sure you installed the right `iOS Distribution` certificate and private key (todo: confirm with Abby where should we store the private key and update this).
3. Build the `portkey-prod` target to `device` and confirm it builds successfully.
4. Create a pull request on GitHub using `master` as base and `stage` as compare.
5. Merge the pull request into `master`. This will trigger a CircleCI build that will update the build number.
6. Wait for CircleCI to complete and get the build number (it will be added as a tag on GitHub).
7. Update the build number in both `portkey-prod` and `portkey-prod-extension` targets.
8. Archive a build.
9. When it's done, open Xcode's Organizer, select the just archived build and click on `Upload to App Store`.
10. Follow the on-screen steps and upload the archived build to iTunes. After it's done uploading, iTunes Connect will process the archive (this takes a while). When it's ready you'll get an e-mail from iTunes Connect saying that processing is done.
11. Open iTunes Connect (https://itunesconnect.apple.com).
12. Select `Signal` in `My Apps`.
13. Go to the `TestFlight` tab.
14. In both `Internal Testing` and `External Testing`, click on `Select Version to Test` and select your build. If the version number changed, the build might have to be reviewed by Apple before it's available.