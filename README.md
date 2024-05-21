# BTC Direct SDK

[![pub](https://img.shields.io/pub/v/btc_direct.svg)](https://pub.dev/packages/btc_direct) [![points](https://img.shields.io/pub/points/btc_direct)](https://pub.dev/packages/btc_direct) [![popularity](https://img.shields.io/pub/popularity/btc_direct)](https://pub.dev/packages/btc_direct) [![likes](https://img.shields.io/pub/likes/btc_direct)](https://pub.dev/packages/btc_direct)

-   Streamline token purchases with BTC Direct package: enter wallet details, select tokens, choose payment methods, and complete KYC verification effortlessly. Ideal for secure token transactions.

### Features

-   Secure and easy-to-use API for buying and selling crypto
-   Seamless integration into your Flutter app
-   Comprehensive documentation and examples

### Requirements

-   iOS 13.0 or later is required.
-   Update your ios/Podfile:
    ```ruby
    source 'https://cdn.cocoapods.org/'
    source 'https://github.com/SumSubstance/Specs.git'
    # Enable MRTDReader (NFC) module
    ENV['IDENSIC_WITH_MRTDREADER'] = 'true'
    # Enable VideoIdent module
    ENV['IDENSIC_WITH_VIDEOIDENT'] = 'true'
    ```
-   Update your ios/Runner/Info.plist:
    ```xml
    <key>NSCameraUsageDescription</key>
    <string>Let us take a photo.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Time to record a video.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Let us pick a photo.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Please provide us with your geolocation data to prove your current location.</string>
    <key>NFCReaderUsageDescription</key>
    <string>Let us scan the document for more precise recognition</string>
    <key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
    <array>
    <string>A0000002471001</string>
    <string>A0000002472001</string>
    <string>00000000000000</string>
    </array>
    ```
-   Ensure that you have bitcode disabled for the whole project and for the flutter_idensic_mobile_sdk_plugin target under Pods project in particular (Pods -> flutter_idensic_mobile_sdk_plugin -> Build Settings -> Enable Bitcode -> No). See more details here.

### Android

-   Change the minSdkVersion to 21 (or higher) in your android/app/build.gradle file.
-   Declare the following permissions:
    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    ```

## Installation

Add btc_direct as a dependency in your pubspec.yaml file.

## Usage

```dart
BTCDirect(
  myAddressesList: [
    {
      "address": "sender_wallet_address", "currency": "BTC",
      "id": '1',
      "name": "Sender's Wallet"
    },
  ],
  xApiKey: "your_api_key_here",
  isSandBox:true,
);
```

## Privacy

### iOS

<b>Requirements</b>

-   Usage: App Functionality (covers fraud prevention)
-   Are the device IDs collected from this app linked to the user’s identity? Yes
-   Do you or your third-party partners use device IDs for tracking purposes? Yes

### Android

<b>Requirement</b>

-   Any data provided by the user is solely used for facilitating transactions through BTC Direct and is not shared with any third parties. See more details here.
-   When publishing to the Play Store, disclose the usage of Device Identifiers as follows:
  -   Data Types: Device or other IDs
  -   Collected: Yes
  -   Shared: No
  -   Processed Ephemerally: No
  -   Required or Optional: Required
  -   Purposes: Fraud Prevention

## Contributing

We welcome contributions to the BTC Direct SDK! Please submit a pull request with your proposed changes.
