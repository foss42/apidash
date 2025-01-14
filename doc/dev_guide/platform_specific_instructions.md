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
### Why is this necessary?  
Android apps can encounter a **65k method limit** if you have many dependencies or a large app. Enabling `multiDex` allows your app to split into multiple DEX files, ensuring it can load and execute all required methods without any runtime errors.  

For more information on multidex support, you can refer to the Android developer guide on [Configuring Multidex](https://developer.android.com/studio/build/multidex).  


### Web  

If you're building a Flutter app for the web using the `printing` package, you may encounter a build error like:  

```
Error: A value of type 'JSString' can't be assigned to a variable of type 'String'.
```

This happens because `.toJS` is no longer required for converting Dart strings to JavaScript strings in recent Dart versions.  

**Fix:**  
Update the `printing_web.dart` file in the `printing` package by removing `.toJS` from:  

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

This fix ensures compatibility with the latest Dart runtime. For more details, refer to [GitHub Issue #1791](https://github.com/DavBfr/dart_pdf/issues/1791).
Read more about it here - https://github.com/DavBfr/dart_pdf/issues/1791
