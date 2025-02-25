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

## Android

In case you are targeting the Android API level <21 or the project and the libraries it references exceed 65,536 methods, you encounter the following build error that indicates your app has reached the limit of the Android build architecture:
  
```
trouble writing output:
Too many field references: 131000; max is 65536.
You may try using --multi-dex option.
```

OR

```
Conversion to Dalvik format failed:
Unable to execute dex: method ID not in [0, 0xffff]: 65536
```

To solve this problem, add the `multiDexEnabled true` line to the `defaultConfig` section in `android/app/build.gradle file`

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

If you are experiencing build failure issues while debugging due to Gradle/JDK/AGP version resolving try upgrading the gradle version by CLI command

```
gradle wrapper --gradle-version <latest compatible version>
```

In case the above command fails, edit the Gradle distribution reference in the `gradle/wrapper/gradle-wrapper.properties` file. The following example sets the Gradle version to 8.8 in the `gradle-wrapper.properties` file.

```
...
distributionUrl = https\://services.gradle.org/distributions/gradle-8.8-bin.zip
...
```

Upgrade AGP by specifying the plugin version in the top-level `build.gradle` file. The following example sets the plugin to version 8.8.0 from the `build.gradle` file:

```
plugins {
...
id 'com.android.application' version '8.8.0' apply false
id 'com.android.library' version '8.8.0' apply false
... 
}
```

For more information on:
- Gradle and Java version compatibility, you can refer to [Compatibility Matrix](https://docs.gradle.org/current/userguide/compatibility.html).
- Gradle and Android Gradle Plugin compatibility, you can refer to [Update Gradle](https://developer.android.com/build/releases/gradle-plugin).

Note : It is highly recommended that always ensure gradle and agp versions are compatible with your JDK version not the vice-versa and having atleast JDK 17 is recommmended.

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
