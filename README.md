# mis

## References
# flavors
https://www.launchclub.io/blog/flutter-flavors-environment-and-app-icons


## Commands
## asset generate command 
  Run the below command everytime when you make any changes in the asset folder.
-- dart run build_runner build --delete-conflicting-outputs 

  Run the below command for create flavor app icons for android and ios
-- flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons*


## Build falvor app
flutter build apk --flavor uat -t lib/main_uat.dart
flutter build apk --flavor prod -t lib/main.dart
flutter build apk --flavor dev -t lib/main_dev.dart


-- rm -rf Pods/ Podfile.lock ; pod install

rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec


## Command for configure native splash screen
dart run flutter_native_splash:create --path=flutter_native_splash-demoUat.yaml
dart run flutter_native_splash:create --path=flutter_native_splash-demoUat.yaml
dart run flutter_native_splash:create --path=flutter_native_splash-demoProd.yaml
dart run flutter_native_splash:create --path=flutter_native_splash-seemattiUat.yaml
dart run flutter_launcher_icons:main -f flutter_launcher_icons-demoLaunch.yaml


