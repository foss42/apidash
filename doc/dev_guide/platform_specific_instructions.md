# Platform-specific Additional Instructions

## macOS

Add below keys to `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`.

```
	<key>com.apple.security.network.server</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
	<key>com.apple.security.files.downloads.read-write</key>
	<true/>
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
```

If not added, you can encounter a network connection error similar to the following while running your Flutter app on macOS:

```
ClientException with SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
```

You can read more [here](https://docs.flutter.dev/platform-integration/macos/building#setting-up-entitlements)

In case you are having a local build failure on macOS due to "audio_session" do check out issue https://github.com/foss42/apidash/issues/510 for solution.

## Android (Work in Progress)

Add the `multiDexEnabled true` line to the `defaultConfig` section at `android/app/build.gradle file`

```
android {
    ...
    defaultConfig {
        ...
        multiDexEnabled true
    }
}
```

For more information on multidex support, you can refer to the Android developer guide on [Configuring Multidex](https://developer.android.com/studio/build/multidex).  

## Web  

If you're building a Flutter app for the web, you may encounter a build error like:  

```
Launching lib/main.dart on Chrome in debug mode...
../../../.pub-cache/hosted/pub.dev/printing-5.13.4/lib/printing_web.dart:218:16: Error: 
A value of type 'JSString' can't be assigned to a variable of type 'String'.
              .toJS;
               ^
Failed to compile application.
```

This happens because `.toJS` is no longer required for converting Dart strings to JavaScript strings in recent Dart versions.  

**Fix:**  
Update the `printing_web.dart` file in the cached `printing` package by removing `.toJS` as done in the PR [here](https://github.com/DavBfr/dart_pdf/pull/1739/files)

```dart
script.innerHTML =
    '''function ${_frameId}_print(){var f=document.getElementById('$_frameId');f.focus();f.contentWindow.print();}'''
        .toJS;
```

Change it to:  
```dart
script.innerHTML =
    '''function ${_frameId}_print(){var f=document.getElementById('$_frameId');f.focus();f.contentWindow.print();}''';
```

Read more about it here - https://github.com/DavBfr/dart_pdf/issues/1791
