# How to run API Dash locally?

#### 1. Fork the project.

#### 2. Create a clone of the forked project on your computer to run it locally.

#### 3. Based on your desktop environment, enable Windows, macOS, or Linux for the project. Select the same target device.  
Choose any of the following platforms: `windows`, `macos`, `linux`, `android` or `ios`.

```bash
flutter create --platforms=<platform> .
```

#### 4. Check [platform_specific_instructions.md](https://github.com/imukulgehlot/apidash/blob/setup-run-platform-guide/doc/dev_guide/platform_specific_instructions.md) to add required platform specific configurations.   

#### 5. Setup melos

As API Dash is a monorepo with multi-package architecture we use [melos](https://pub.dev/packages/melos). 

```
dart pub global activate melos
```

Bootstrap to initialize the workspace, link local packages together and install remaining package dependencies. 

```
melos bootstrap
```

Get all dependencies of packages

```
melos pub-get
```

#### 6. Get all dependencies of the app

```
flutter pub get
```

#### 7. Run the project by executing the below command

```
flutter run
```
