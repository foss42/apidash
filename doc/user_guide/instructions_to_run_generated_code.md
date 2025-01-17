# How to Run Generated Code for a Programming Language 

Choose your programming language/library from the list provided below to learn more how you can execute them: 
- [cURL](#curl)
- [C (libcurl)](#c-libcurl)
- [C# (HttpClient)](#c-httpclient)
- [C# (RestSharp)](#c-restsharp)
- [Dart (http)](#dart-http)
- [Dart (dio)](#dart-dio)
- [Go (net/http)](#go-nethttp)
- [JavaScript (axios)](#javascript-axios)
- [JavaScript (fetch)](#javascript-fetch)
- [node.js (JavaScript, axios)](#nodejs-javascript-axios)
- [node.js (JavaScript, fetch)](#nodejs-javascript-fetch)
- [Java (asynchttpclient)](#java-asynchttpclient)
- [Java (HttpClient)](#java-httpclient)
- [Java (okhttp3)](#java-okhttp3)
- [Java (Unirest)](#java-unirest)
- [Julia (HTTP)](#julia-http)
- [Kotlin (okhttp3)](#kotlin-okhttp3)
- [PHP (curl)](#php-curl)
- [PHP (guzzle)](#php-guzzle)
- [PHP (HTTPlug)](#php-httplug)
- [Python (requests)](#python-requests)
- [Python (http.client)](#python-httpclient)
- [Ruby (faraday)](#ruby-faraday)
- [Ruby (net/http)](#ruby-nethttp)
- [Rust (hyper)](#rust-hyper)
- [Rust (reqwest)](#rust-reqwest)
- [Rust (ureq)](#rust-ureq)
- [Rust (Actix Client)](#rust-actix-client)
- [Swift](#swift)

**Please raise a GitHub issue in case any instruction is not clear or if it is not working.**

## cURL

TODO

## C (libcurl)

TODO

## C# (HttpClient)

TODO

## C# (RestSharp)

TODO

## Dart (http)

Here are the detailed instructions for running the generated API Dash code in **Dart (using `http`)** for macOS, Windows, and Linux:

### **1. Install Dart**

- Visit the official **[Dart Installation Guide](https://dart.dev/get-dart)** for step-by-step installation instructions for macOS, Windows, and Linux.

### **2. Add the `http` Package**

- Add the `http` package as a dependency under the `dependencies` section of the `pubspec.yaml` file:  
   ```yaml
   dependencies:
     http: ^1.2.2
   ```  
- Run the following command to fetch the dependency:  
   ```bash
   dart pub get
   ```

### **3. Run the Generated Code**

#### **Using a Text Editor or IDE (e.g., Visual Studio Code):**
1. Open a text editor or an IDE like Visual Studio Code.
2. Create a new Dart file, such as `api_test.dart`.
3. Copy the generated code from API Dash and paste it into this file.
4. Save the file.
5. Run the Dart file using the terminal or the IDE's built-in tools.

#### **Using the Command Line:**
1. Save the generated code to a Dart file, e.g., `api_test.dart`.
2. Open a terminal and navigate to the directory containing the file.
3. Run the Dart file with the following command:  
   ```bash
   dart run api_test.dart
   ```

## Dart (dio)

Here are the detailed instructions for running the generated API Dash code in **Dart (using `dio`)** for macOS, Windows, and Linux:

### **1. Install Dart**

- Visit the official **[Dart Installation Guide](https://dart.dev/get-dart)** for step-by-step installation instructions for macOS, Windows, and Linux.

### **2. Add the `dio` Package**

- Add the `dio` package as a dependency under the `dependencies` section of the `pubspec.yaml` file:  
   ```yaml
   dependencies:
     dio: ^5.7.0
   ```  
- Run the following command to fetch the dependency:  
   ```bash
   dart pub get
   ```

### **3. Run the Generated Code**  

#### **Using a Text Editor or IDE (e.g., Visual Studio Code):**
1. Open a text editor or an IDE like Visual Studio Code.
2. Create a new Dart file, such as `api_test.dart`.
3. Copy the generated code from API Dash and paste it into this file.
4. Save the file.
5. Run the Dart file using the terminal or the IDE's built-in tools.

#### **Using the Command Line:**
1. Save the generated code to a Dart file, e.g., `api_test.dart`.
2. Open a terminal and navigate to the directory containing the file.
3. Run the Dart file with the following command:  
   ```bash
   dart run api_test.dart
   ```

## Go (net/http)

TODO

## JavaScript (axios)

TODO

## JavaScript (fetch)

TODO

## node.js (JavaScript, axios)

TODO

## node.js (JavaScript, fetch)

TODO

## Java (asynchttpclient)

TODO

## Java (HttpClient)

TODO

## Java (okhttp3)

TODO

## Java (Unirest)

TODO

## Julia (HTTP)

TODO

## Kotlin (okhttp3)

TODO

## PHP (curl)

TODO

## PHP (guzzle)

TODO

## PHP (HTTPlug)

TODO

## Python (requests)

Here are the detailed instructions for running the generated API Dash code in Python (using `requests`) for macOS, Windows, and Linux:

### 1. Install Python:
#### macOS:
- Go to the official Python website: [https://www.python.org/downloads/macos/](https://www.python.org/downloads/macos/)
- Download the latest version for macOS and follow the installation instructions.

#### Windows:
- Go to the official Python website: [https://www.python.org/downloads/](https://www.python.org/downloads/)
- Download the latest version for Windows and run the installer. During installation, make sure to check the box that says "Add Python to PATH."

#### Linux:
- Most Linux distributions come with Python pre-installed. To check if Python is already installed, open the terminal and type:

```bash
python3 --version
```

- If it's not installed, you can install it via your package manager:
  - On Ubuntu/Debian-based systems:

    ```bash
    sudo apt update
    sudo apt install python3
    ```

  - On Fedora/CentOS-based systems:

    ```bash
    sudo dnf install python3
    ```

### 2. Install the `requests` library:
#### macOS and Linux:
Open the terminal and type the following command to install the `requests` library using `pip`:

```bash
pip3 install requests
```

#### Windows:
Open Command Prompt (or PowerShell) and type the following command to install the `requests` library using `pip`:

```bash
pip install requests
```

### 3. Execute the generated code:
Once you have Python and `requests` installed, follow these steps to execute the generated code:

1. **Open a text editor** ✍️ (like Notepad on Windows, TextEdit on macOS, or any code editor like Visual Studio Code).
2. **Copy the generated code** 📋 from API Dash.
3. **Paste the code** into the text editor 🔄.
4. **Save the file** 💾 with a `.py` extension, such as `api_test.py`.

This makes the steps a little more visual and fun!

#### macOS and Linux:
1. Open the **Terminal**.
2. **Navigate to the directory** where you saved the `.py` file. For example:

```bash
cd /path/to/your/file
```

3. **Run the Python script** by typing the following command:

```bash
python3 api_test.py
```

#### Windows:
1. Open **Command Prompt** (or PowerShell).
2. **Navigate to the directory** where you saved the `.py` file. For example:

```bash
cd C:\path\to\your\file
```

3. **Run the Python script** by typing the following command:

```bash
python api_test.py
```

## Python (http.client)

Here are the detailed instructions for running the generated API Dash code in Python using `http.client`:

### 1. Install Python:
Check out the instructions [here](#1-install-python) for detailed steps on how to install Python on macOS, Windows, or Linux.

### 2. `http.client` is a built-in library:
Unlike other Python libraries (like `requests`), `http.client` is part of Python's standard library. You can directly use it without any additional installation steps.

### 3. Execute the generated code:
Check out the instructions [here](#3-execute-the-generated-code) for detailed steps on how to run the code.

## Ruby (faraday)

TODO

## Ruby (net/http)

TODO

## Rust (hyper)

TODO

## Rust (reqwest)

TODO

## Rust (ureq)

TODO

## Rust (Actix Client)

TODO

## Swift

TODO
