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
