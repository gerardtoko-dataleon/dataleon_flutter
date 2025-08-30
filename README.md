
# dataleon_flutter

> Flutter SDK for Dataleon verification integration via WebView.

## 4️⃣ Add permissions for Android & iOS

### Android (`android/app/src/main/AndroidManifest.xml`)

Add the following lines inside the `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### iOS (`ios/Runner/Info.plist`)

Add these keys to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access for verification</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for verification</string>
```

## Installation


Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dataleon_flutter: ^1.0.1
```

Then run:

```sh
flutter pub get
```


## Usage

```dart
import 'package:dataleon_flutter/dataleon_flutter.dart';

// ...

ElevatedButton(
  onPressed: () {
    Dataleon.launch(
      context: context,
      sessionUrl: 'https://id.dataleon.ai/w/76bf997a-xxxxx',
      onResult: (status, [error]) {
        if (status == Dataleon.statusDone) {
          // Success
        } else if (status == Dataleon.statusCanceled) {
          // Canceled by user
        } else if (status == Dataleon.statusError) {
          // Error: $error
        }
      },
    );
  },
  child: Text('Start verification'),
)
```

### Close the modal programmatically

You can close the Dataleon modal at any time using:

```dart
Dataleon.closeModal(context);
```

## Dependencies
- [webview_flutter](https://pub.dev/packages/webview_flutter)
- [permission_handler](https://pub.dev/packages/permission_handler)

## License

MIT
