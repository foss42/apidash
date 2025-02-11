# Packaging API Dash

## Windows

[Packaging and Distributing Flutter Desktop Apps : Creating Windows .exe installer](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-for-open-source-indie-0b468d5e9e70)

## macOS

[Packaging and Distributing Flutter Desktop Apps: Creating macOS .app & .dmg](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285)

## Linux Debian (.deb) & RPM (.rpm)

[Packaging and Distributing Flutter Desktop Apps: Creating Linux Debian (.deb) & RPM (.rpm) builds](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-for-open-source-indie-24ef8d30a5b4)

## Arch Linux (PKGBUILD)

TODO Instructions

## FlatHub (Flatpak)

TODO Instructions

## Homebrew

TODO Instructions

## Chocolatey

### Step 1: Setup Skeleton

First step towards making a choco package is initializing a base.

The command `choco new -h` can teach you more about the `new` command, its usage, options, switches, and exit codes.

Run the following command to setup the base

```powershell
choco new --name="apidash" --version="0.3.0" maintainername="foss42" maintainerrepo="https://github.com/foss42/apidash" --built-in-template
```

![choco folder structure](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/lzxebtal5tt1u2o4n5hp.png)

This creates the following folder structure

```
apidash
├── ReadMe.md
├── _TODO.txt
├── apidash.nuspec
└── tools
    ├── chocolateybeforemodify.ps1
    ├── chocolateyinstall.ps1
    ├── chocolateyuninstall.ps1
    ├── LICENSE.txt
    └── VERIFICATION.txt
```

The files `ReadMe.md` and `_TODO.md` can be deleted before pushing.

The files of our main interest are `chocolateyinstall.ps1` and `apidash.nuspec`.

### Step 2: Editing `chocolateyinstall.ps1`

Take a look at `chocolateyinstall.ps1` file. There are many comments stating the use case of each line itself.
![chocolatelyinstall.ps1](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/boc5lcstslju2qtey9cm.png)

Comments can bre remoed using the following command.
```powershell
$f='apidash\tools\chocolateyinstall.ps1'
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*? [^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f
```


Now our `chocolateyinstall.ps1` file is ready.

### Step 3: Editing `apidash.nuspec`

![final apidash.nuspec](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2km555bocw3upnkulj1y.png)

### Step 4: Build the package

All our files are ready, we just need to pack out files in a choco package with the extension `.nupkg`.

Run the following command from the root of your directory:
```powershell
choco pack 
```
This command generates the `apidash.0.3.0.nupkg` file.

### Step 5: Test the Package Locally

Install the package locally using Chocolatey:
```powershell
choco install apidash -s .
```
Ensure the application installs correctly.

![Shell output](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/98yzsrhm1tnld8ylatt3.png)

### Step 6: Pre-Publishing - Update `LICENSE.txt` & `VERIFICATION.txt`

Update `LICENSE.txt` with the actual **LICENSE **and `VERIFICATION.txt` accordingly.

### Step 7: Publish the Package (Optional)

To share the package, you can push it to a Chocolatey repository. For the official Chocolatey Community Repository, follow these steps:

1. Create an account on the Chocolatey Community.
2. Get an API key by navigating to your profile.
3. Use the following command to push your package:
```powershell
choco push apidash.0.3.0.nupkg --source="https://push.chocolatey.org/" --api-key="YOUR_API_KEY"
```

## WinGet

TODo Instructions
