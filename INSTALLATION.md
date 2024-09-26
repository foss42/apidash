# Installation Instructions

## Windows 
Download the latest Windows Installer (64 bit) from [here](https://github.com/foss42/apidash/releases/latest)

To install it, simply double click on the installer.

If prompted by Windows that **Windows prevented an unrecognized app from running**, click on **Run anyway**. 

Now, follow the step by step installation wizard.

## MacOS

Download the latest MacOS Installer (Universal - Intel and Apple Silicon) from [here](https://github.com/foss42/apidash/releases/latest)

**As this app is distributed outside the App Store you have to follow the following instructions to setup and run it only for the first time.**

![‎installation ‎001](https://github.com/foss42/apidash/assets/1382619/05c05272-8bff-42a5-9203-c51a66d22f5d)

![‎installation ‎002](https://github.com/foss42/apidash/assets/1382619/a729d2fc-a863-4704-b9c6-eed4c3704175)

![‎installation ‎003](https://github.com/foss42/apidash/assets/1382619/b07a5563-aeda-48b3-912f-578e50275579)

![‎installation ‎004](https://github.com/foss42/apidash/assets/1382619/e09bc786-fada-4874-aa6f-8f104797472f)

![‎installation ‎005](https://github.com/foss42/apidash/assets/1382619/a3a60cdb-e15b-4268-93e5-cc4b203bbe64)

![‎installation ‎006](https://github.com/foss42/apidash/assets/1382619/c34824d2-6848-42fa-8731-da3a40790144)

![‎installation ‎007](https://github.com/foss42/apidash/assets/1382619/d1f96bd1-d847-4966-b225-f69ca562d9ad)

![‎installation ‎008](https://github.com/foss42/apidash/assets/1382619/929acfae-0d2e-4de0-8158-469c8e12b487)

![‎installation ‎009](https://github.com/foss42/apidash/assets/1382619/3cf1d94b-0ec3-4ba8-b981-54d3f9dd0d2d)


This process has to be followed only once and from the next time you can directly launch the API Dash App from the Launchpad.

##

You can refer to the video given below which shows the steps to install and run API Dash on macOS.

https://user-images.githubusercontent.com/1382619/227956871-87376f18-d80f-4a53-9456-cb724f8149c7.mp4

## Linux

### Debian-based Linux Distributions (Debian, Ubuntu, Linux Mint, etc.)

Download the `.deb` file from the [latest release](https://github.com/foss42/apidash/releases/latest) corresponding to you CPU architecture (x64/amd64 or arm64).

`cd` to the Downloads folder and execute the following command to install API Dash.

```
sudo apt install ./apidash-<fullname>.deb
```

or

```
sudo dpkg -i apidash-<fullname>.deb
```

Launch API Dash via `apidash` command or by clicking on the API Dash app icon.

### Red Hat-based Linux Distributions (Fedora, Rocky, AlmaLinux, CentOS, RHEL, etc.)

Download the `.rpm` file from the [latest release](https://github.com/foss42/apidash/releases/latest) corresponding to you CPU architecture (x86_64 or aarch64/arm64).

`cd` to the Downloads folder and execute the following command to install API Dash.

```
sudo dnf localinstall ./apidash-<fullname>.rpm
```

or

```
sudo rpm -i apidash-<fullname>.rpm
```

or

```
sudo yum localinstall ./apidash-<fullname>.rpm
```

Launch API Dash via `apidash` command or by clicking on the API Dash app icon.

### Arch-based Linux Distributions (Manjaro, Arch Linux, etc.)

Download the `.deb` file from the [latest release](https://github.com/foss42/apidash/releases/latest) corresponding to your CPU architecture (x86_64/amd64 or arm64/aarch64).

First we have to convert the .deb file to .tar.xz file using the following commands.

1. Install debtap using the following command.
    ```
    yay -S debtap
    ```

2. Initialize `debtap` using the following command.
    ```
    sudo debtap -u
    ```

3. Convert the .deb file to .tar.xz file using the following command.
    ```
    sudo debtap /path/to/apidash-<fullname>.deb
    ```
4. Once converted, install the resulting .tar.xz file using the following command.
    ```
    sudo pacman -U apidash-<fullname>.tar.xz
    ```

Note: Replace `/path/to/apidash-<fullname>.deb` with the path to the downloaded .deb file.

Launch API Dash via `apidash` command or by clicking on the API Dash app icon.
