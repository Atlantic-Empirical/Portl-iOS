fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs all the tests
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios enterprise_prod_build
```
fastlane ios enterprise_prod_build
```
Build with Enterprise Signing, pointed at Production environment
### ios enterprise_stage_build
```
fastlane ios enterprise_stage_build
```
Build with Enterprise Signing, pointed at Staging environment

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).
