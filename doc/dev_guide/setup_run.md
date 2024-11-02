# How to run API Dash locally?

1. Fork the project.
2. Create a clone of the forked project on your computer to run it locally.
3. Based on your desktop environment, enable Windows, macOS or Linux for the project. Select the same target device.

#### 4. Setup melos

As API Dash is a monorepo with multi-package architecture we use [melos](https://pub.dev/packages/melos). 

```
dart pub global activate melos
```

Bootstrap to initialize the workspace, link local packages together and install remaining package dependencies. 

```
melos bootstrap
```

Get all dependencies

```
melos pub-get
flutter pub get
```

Run the project by executing the following command:

```
flutter run
```
