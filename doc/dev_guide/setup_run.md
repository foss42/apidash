# How to run API Dash locally?

**Step 1 -** Fork the project.

**Step 2 -** Create a clone of the forked project on your computer to run it locally.

**Step 3 -** Based on your desktop environment, enable Windows, macOS, or Linux for the project. Select the same target device.  
Choose any of the following platforms: `windows`, `macos`, `linux`, `android` or `ios`.

```bash
flutter create --platforms=<platform> .
```

**Step 4 -** Check [Platform Specific Instructions](https://github.com/foss42/apidash/blob/main/doc/dev_guide/platform_specific_instructions.md) to add required platform specific configurations.   

**Step 5 -** Setup melos

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

**Step 6 -** Get all dependencies of the app

```
flutter pub get
```

**Step 7 -** Run the project by executing the below command

```
flutter run
```
