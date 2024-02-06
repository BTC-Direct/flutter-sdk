# btcdirect

A new Flutter project.

## Local development setup

To setup your local development / testing environment, the following steps are needed.

### Install Flutter, Dart and Android Studio

The installation instructions can be found in the Flutter development documentation:
* (Linux)[https://docs.flutter.dev/get-started/install/linux]
* (MacOS - Android)[https://docs.flutter.dev/get-started/install/macos/mobile-android]
* (MacOS - iOS)[https://docs.flutter.dev/get-started/install/macos/mobile-ios]

### Setup a device in Android Studio

To add a device (emulator) in Android Studio, follow the instructions from the link in the above section.
For more detailed information you can reference Android Studio's (Create and manage virtual devices)[https://developer.android.com/studio/run/managing-avds] page.

### Run a device

From Android Studio's Device Manager, press the "play"-icon to start the device.

#### Run a device from VS Code

In order to run a device from VS Code, the following steps are needed:
* Install the (Flutter extension)[https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter]
* Start a device from the bottom bar. For more information see the (Running and debugging documentation)[https://docs.flutter.dev/tools/vs-code#running-and-debugging]

### Start the app

Once your device is up-and-running you can start the app in the running device. There are three ways to start the app:
* Go to `lib/main.dart`, right-click and select "Run Without Debugging"
* In the top bar, select the "Run" menu-item and select "Run Without Debugging" in the dropdown
* Press the "Ctrl+F5" keys