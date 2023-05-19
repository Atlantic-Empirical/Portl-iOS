# CircleCI

Ok so, CircleCI is doing just enough for us (no tests), and to be honest it is cobbled together (sorry!).

See [scripts/circleci](../scripts/circleci) for related scripts and [circle.yml](../circle.yml) for related config.

Here is the current flow:
- Add the necessary development/provisioning keys using [`add_key.sh`](../scripts/circleci/add_key.sh)
- Make sure everything is set up properly using [`up.sh`](../scripts/circleci/up.sh)
- The primary script: [`script.sh`](../scripts/circleci/script.sh)
  - If a pull request, simply build the `portkey-stage` target in Debug mode with no code signing
  - If master or develop branch, increment the build number, and build in Debug with no code signing
  - If stage branch, increment the build number, build in Release mode with proper code signing, sign the application, and ship to crashlytics
  - Miscellaneous/less important other scenarios in the script
- Remove the previously added keys using [`remove_key.sh`](../scripts/circleci/remove_key.sh)

It will then post status to a Slack webhook (currently dropping into #ios-bots)
