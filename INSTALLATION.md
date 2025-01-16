# Installation Instructions


## Windows 

- Download the latest Windows Installer (64 bit) from [here](https://github.com/foss42/apidash/releases/latest)
- To install it, simply double click on the installer.
- If prompted by Windows that **Windows prevented an unrecognized app from running**, click on **Run anyway**. 
- Now, follow the step by step installation wizard.

Detailed, step by step instructions are provided below:

### Step 1: Download the Installer  
1. Visit the [latest release page](https://github.com/foss42/apidash/releases/latest) on GitHub.  
2. Download the **Windows Installer (64-bit)** file.

### Step 2: Install the Application  
1. Locate the downloaded installer file (usually found in your `Downloads` folder).  
2. Double-click on the installer to begin the installation process.  

### Step 3: Handle Windows Security Warnings  
- **Unrecognized App Warning**:  
  If you see a message saying:  
  > *Windows protected your PC*  
  This occurs because the app is from an unrecognized publisher.  
  - Click on **More info**.  
  - Then, click on **Run anyway** to proceed.  

### Step 4: Follow the Installation Wizard  
1. Follow the step-by-step instructions provided in the installation wizard.  
2. Customize the installation location if required, or proceed with the default options.  
3. Click **Install** to complete the process.  

### Step 5: Launch the Application  
Once the installation is complete, you can:  
- Launch the application directly from the final screen of the installer.  
- Or, open it later from the Start Menu or Desktop shortcut.

## MacOS

Download the latest MacOS Installer (Universal - Intel and Apple Silicon) from [here](https://github.com/foss42/apidash/releases/latest)

**As this app is distributed outside the App Store you have to follow the following instructions to setup and run it only for the first time.**

![‎installation ‎001](https://github.com/foss42/apidash/assets/1382619/05c05272-8bff-42a5-9203-c51a66d22f5d)

![‎installation ‎002](https://github.com/foss42/apidash/assets/1382619/a729d2fc-a863-4704-b9c6-eed4c3704175)

![‎installation ‎003](https://github.com/foss42/apidash/assets/1382619/b07a5563-aeda-48b3-912f-578e50275579)


In case, you see a different dialog other than the one shown below, check out [this section](#open-via-settings)

![‎installation ‎004](https://github.com/foss42/apidash/assets/1382619/e09bc786-fada-4874-aa6f-8f104797472f)

![‎installation ‎005](https://github.com/foss42/apidash/assets/1382619/a3a60cdb-e15b-4268-93e5-cc4b203bbe64)

![‎installation ‎006](https://github.com/foss42/apidash/assets/1382619/c34824d2-6848-42fa-8731-da3a40790144)

![‎installation ‎007](https://github.com/foss42/apidash/assets/1382619/d1f96bd1-d847-4966-b225-f69ca562d9ad)

![‎installation ‎008](https://github.com/foss42/apidash/assets/1382619/929acfae-0d2e-4de0-8158-469c8e12b487)

![‎installation ‎009](https://github.com/foss42/apidash/assets/1382619/3cf1d94b-0ec3-4ba8-b981-54d3f9dd0d2d)

This process has to be followed only once and from the next time you can directly launch the API Dash App from the Launchpad.

### Open via Settings

In macOS, if you do not get an option to open immediately, follow the following steps to install API Dash:

![‎installation ‎010](https://github.com/user-attachments/assets/22f6c659-60c9-4332-85b5-6f6e6fffdffd)

Go to Settings > Privacy and Security

![‎installation ‎011](https://github.com/user-attachments/assets/a8abc503-482e-4d19-bd73-79a5d79fc3c6)

![‎installation ‎012](https://github.com/user-attachments/assets/c543b65e-745e-48b0-8af8-7eab60fe3463)

Now drag to the `Applications` folder 

![‎installation ‎012](https://github.com/user-attachments/assets/82257ba1-1eeb-4618-b09a-ea2fd5bb3d36)

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
