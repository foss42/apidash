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
- [Swift (URLSession)](#swift-urlsession)
- [Swift (Alamofire)](#swift-alamofire)

**Please raise a GitHub issue in case any instruction is not clear or if it is not working.**

## cURL

cURL is a command-line tool for making HTTP requests. It comes pre-installed on most operating systems.

### 1. Verify cURL Installation

#### macOS and Linux:
cURL is pre-installed on most macOS and Linux systems. Verify by running:
```bash
curl --version
```

#### Windows:
cURL is included in Windows 10 (version 1803) and later. Verify by running in Command Prompt or PowerShell:
```bash
curl --version
```

If cURL is not installed on Windows, you can:
- Download it from [curl.se/windows](https://curl.se/windows/)
- Or install via package managers like [Chocolatey](https://chocolatey.org/):
  ```bash
  choco install curl
  ```

### 2. Execute the Generated Code

Once you have cURL installed, follow these steps to execute the generated code:

1. **Copy the generated cURL command** from API Dash.
2. **Open a terminal** (macOS/Linux) or **Command Prompt/PowerShell** (Windows).
3. **Paste and run the command** directly in the terminal.

The API response will be displayed in the terminal output.

### 3. Tips for Using cURL

- **Save output to a file**: Add `-o filename.txt` to save the response
  ```bash
  curl https://api.example.com -o response.txt
  ```

- **View response headers**: Add `-i` or `--include` flag
  ```bash
  curl -i https://api.example.com
  ```

- **Follow redirects**: Add `-L` or `--location` flag
  ```bash
  curl -L https://api.example.com
  ```

- **Verbose output** (for debugging): Add `-v` or `--verbose` flag
  ```bash
  curl -v https://api.example.com
  ```

## C (libcurl)

Here are the detailed instructions for running the generated API Dash code in C (using `libcurl`) for macOS, Windows, and Linux:

### 1. Install C Compiler and libcurl

#### macOS:
1. **Install Xcode Command Line Tools** (includes GCC/Clang compiler):
   ```bash
   xcode-select --install
   ```

2. **Install libcurl** (usually pre-installed on macOS):
   - Verify installation:
     ```bash
     curl-config --version
     ```
   - If not installed, use Homebrew:
     ```bash
     brew install curl
     ```

#### Windows:
1. **Install a C Compiler**:
   - Download and install [MinGW-w64](https://www.mingw-w64.org/) or [TDM-GCC](https://jmeubank.github.io/tdm-gcc/)
   - Or install Visual Studio with C++ development tools

2. **Install libcurl**:
   - Download pre-built binaries from [curl.se/windows](https://curl.se/windows/)
   - Or use [vcpkg](https://github.com/microsoft/vcpkg):
     ```bash
     vcpkg install curl
     ```

#### Linux:
1. **Install GCC compiler and libcurl development files**:
   - **Ubuntu/Debian**:
     ```bash
     sudo apt update
     sudo apt install build-essential libcurl4-openssl-dev
     ```
   - **Fedora/CentOS**:
     ```bash
     sudo dnf install gcc libcurl-devel
     ```
   - **Arch Linux**:
     ```bash
     sudo pacman -S gcc curl
     ```

### 2. Execute the Generated Code

Once you have GCC and libcurl installed, follow these steps to execute the generated code:

1. **Open a text editor** and create a new file (e.g., `api_test.c`).
2. **Copy the generated code** from API Dash and paste it into the file.
3. **Save the file**.

### 3. Compile and Run

#### macOS and Linux:
1. Open the terminal and navigate to the directory containing your C file.
2. Compile the code with the following command:
   ```bash
   gcc api_test.c -o api_test -lcurl
   ```
3. Run the compiled program:
   ```bash
   ./api_test
   ```

#### Windows (MinGW):
1. Open Command Prompt and navigate to the directory containing your C file.
2. Compile the code:
   ```bash
   gcc api_test.c -o api_test.exe -lcurl
   ```
3. Run the program:
   ```bash
   api_test.exe
   ```

#### Windows (Visual Studio):
1. Create a new C++ Console Application project.
2. Add libcurl include and library paths to your project settings.
3. Paste the generated code into your source file.
4. Build and run the project (F5).

## C# (HttpClient)

Here are the detailed instructions for running the generated API Dash code in C# (using `HttpClient`) for macOS, Windows, and Linux:

### 1. Setting Up the C# Development Environment
#### macOS and Windows:
1. **Install .NET SDK:**
   - Visit the [official .NET download page](https://dotnet.microsoft.com/download).
   - Download and install the latest .NET SDK for macOS.
2. **Verify Installation:**
   - Open the terminal and run the following command to verify the installation:
     ```bash
     dotnet --version
     ```

#### Linux:
1. **Install .NET SDK:**
   - Run the following commands based on your distribution:
     - For Ubuntu/Debian-based systems:
       ```bash
       sudo apt update
       sudo apt install dotnet-sdk-7.0
       ```
     - For Fedora/CentOS-based systems:
       ```bash
       sudo dnf install dotnet-sdk-7.0
       ```
2. **Verify Installation:**
   - Open the terminal and run the following command to verify the installation:
     ```bash
     dotnet --version
     ```

### 2. Preparing a Project

#### In Visual Studio:
1. **Create a New Project:**
   - Open Visual Studio and select **Create a new project**.
   - Choose the **Console Application (.NET Core)** template and create the project.

2. **Check `System.Net.Http` Namespace:**
   - `HttpClient` is included by default. No additional installation is required.

#### Using the CLI:
1. **Create a Project:**
   ```bash
   dotnet new console -n HttpClientExample
   cd HttpClientExample
   ```

2. **Install the Package (if necessary):**
   ```bash
   dotnet add package System.Net.Http
   ```

### 3. Execute the generated code:
Once you have .NET(C#) and `HttpClient` installed, follow these steps to execute the generated code:

1. **Open a IDE/text editor** ✍️ (Visual Studio, VS Code or any other text editor).
2. **Copy the generated code** 📋 from API Dash.
3. **Paste the code** into your project. ex) prgoram.cs

#### In Visual Studio:
1. Click the **Start Debugging (F5)** button from the top menu to run the project.
2. The output window will display the API response.

#### Using the CLI:
1. Open the terminal at the project root directory and run the following command:
   ```bash
   dotnet run
   ```

## C# (RestSharp)

Here are the detailed instructions for running the generated API Dash code in C# (using RestSharp) for macOS, Windows, and Linux:

### 1. Setting Up the C# Development Environment

#### macOS and Windows
1. **Install .NET SDK**
   - Visit the [official .NET download page](https://dotnet.microsoft.com/download).
   - Download and install the latest .NET SDK for macOS.
2. **Verify Installation**
   - Open the terminal and run the following command to verify the installation:
     ```bash
     dotnet --version
     ```

#### Linux
1. **Install .NET SDK**
   - Run the following commands based on your distribution:
     - For Ubuntu/Debian-based systems:
       ```bash
       sudo apt update
       sudo apt install dotnet-sdk-7.0
       ```
     - For Fedora/CentOS-based systems:
       ```bash
       sudo dnf install dotnet-sdk-7.0
       ```
2. **Verify Installation**
   - Open the terminal and run the following command to verify the installation:
     ```bash
     dotnet --version
     ```

### 2. Preparing a Project

#### In Visual Studio

1. **Create a New Project**
   - Open Visual Studio and select **Create a new project**.
   - Choose the **Console Application (.NET Core)** template and create the project.

2. **Install `RestSharp`**
   - Go to Tools > NuGet Package Manager > Manage NuGet Packages for Solution.
   - Under the Browse tab, search for `RestSharp` and install it.

#### Using the CLI

1. **Create a Project**
   ```bash
   dotnet new console -n RestSharpExample
   cd RestSharpExample
   ```

2. **Install the Package**
   ```bash
   dotnet add package RestSharp
   ```
   
### 3. Execute the generated code

Once you have .NET(C#) and `RestSharp` installed, follow these steps to execute the generated code:

1. Open a IDE/text editor (Visual Studio, VS Code or any other text editor).
2. Copy the generated code from API Dash.
3. Paste the code into your project like program.cs

#### In Visual Studio

1. Click the **Start Debugging (F5)** button from the top menu to run the project.
2. The output window will display the API response.

#### Using the CLI

1. Open the terminal at the project root directory and run the following command:
   ```bash
   dotnet run
   ```

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

### 1. Install Go compiler

- Windows and MacOS: check out the [official source](https://go.dev/doc/install)
- Linux: Install from your distro's package manager.

Verify if go is installed:

```bash
go version
```

### 2. Create a project
```bash
go mod init example.com/api
```

### 3. Run the generated code
- Paste the generated code into `main.go`.
- Build and run by `go run main.go`.

## JavaScript (axios)

The generated api code can be run in browser by using the code in an html file as demonstrated below:

### 1. Create the html file with generated code

Create a new file `index.html`

```html
<!DOCTYPE html>
<html>
<head>
    <title>Axios Example</title>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</head>
<body>
    <script>
        // Paste your API Dash generated code here !!
    </script>
</body>
</html>

```

Make sure to paste the generated js code from api dash under the `<script>` tag.

### 2. Test with Browser Developer Tools

Open the `index.html` file in a modern browser and open devtools.

- **Chrome**: Right-click the page and select "Inspect" or press Ctrl+Shift+I (Windows/Linux) or Cmd+Option+I (macOS).

- **Firefox**: Right-click the page and select "Inspect Element" or press Ctrl+Shift+I (Windows/Linux) or Cmd+Option+I (macOS).

- **Edge**: Right-click the page and select "Inspect" or press F12 or Ctrl+Shift+I.

Navigate to network tab and refresh the page to see the requests and network activity.

## JavaScript (fetch)

The generated api code can be run in browser by using the code in an html file as demonstrated below:

### 1. Create the html file with generated code

Create a new file `index.html`

```html
<!DOCTYPE html>
<html>
<head>
    <title>Fetch Example</title>
</head>
<body>
    <script>
        // Paste your API Dash generated code here !!
    </script>
</body>
</html>

```

Make sure to paste the generated js code from api dash under the `<script>` tag.

### 2. Test with Browser Developer Tools

Open the `index.html` file in a modern browser and open devtools.

- **Chrome**: Right-click the page and select "Inspect" or press Ctrl+Shift+I (Windows/Linux) or Cmd+Option+I (macOS).

- **Firefox**: Right-click the page and select "Inspect Element" or press Ctrl+Shift+I (Windows/Linux) or Cmd+Option+I (macOS).

- **Edge**: Right-click the page and select "Inspect" or press F12 or Ctrl+Shift+I.

Navigate to network tab and refresh the page to see the requests and network activity.

## node.js (JavaScript, axios)

### 1.Install Node.js:
Ensure Node.js and npm are installed. Verify by running:

```bash
node --version
npm --version
```

If not, download from Node.js **[Official Website]((https://nodejs.org/en))**.

Initialize a new Node.js project:

```bash
npm init -y
```

Install Axios:

```bash
npm install axios
```

### 2.Set Up a New Project:
Create a new project directory:

```bash
mkdir node-axios-example
cd node-axios-example
```

Initialize the project:

```bash
npm init -y
```

### 3.Create and Run the Code:

Save the generated code in a file(e.g., `app.js`).

Run the code:

```bash
node app.js
```

## node.js (JavaScript, fetch)

### 1. Install Node.js:
Ensure Node.js and npm are installed. Verify by running:

```bash
node --version
npm --version
```

If not, download from Node.js **[Official Website]((https://nodejs.org/en))**.

Initialize a new Node.js project:

```bash
npm init -y
```

If using Node.js 18 or newer, the Fetch API is already built-in.

For older versions, install the `node-fetch` package:

```bash
npm install node-fetch
```

### 2. Set Up a New Project:
Create a project directory:

```bash
mkdir node-fetch-example
cd node-fetch-example
```

Initialize the project:

```bash
npm init -y
```

### 3.Create and Run the Code:
Save the generated code in a file( e.g., `app.js`).
If using `node-fetch`, add the following line to the top of the file:

```javascript
const fetch = require('node-fetch');
```

Run the file:

```bash
node app.js
```

## Java (asynchttpclient)

Here are the detailed instructions for running the generated API Dash code in **Java (using `AsyncHttpClient`)** for macOS, Windows, and Linux:

### 1. Install Java

To run Java code, you need to have Java Development Kit (JDK) installed on your system.

- Visit the official **[Java Downloads Page](https://www.oracle.com/in/java/technologies/downloads/#jdk23)** and follow the instructions to install the latest JDK on macOS, Windows, or Linux.

After installation, verify it by running:

```bash
java -version
```

### 2. Add the `AsyncHttpClient` Library

To use the `AsyncHttpClient` library in Java, you need to add it as a dependency in your project.  

#### Using Maven

1. Add the following dependency to your `pom.xml` file:  
   ```xml
    <dependencies>
      <dependency>
          <groupId>org.asynchttpclient</groupId>
          <artifactId>async-http-client</artifactId>
          <version>3.0.1</version>
      </dependency>
    </dependencies>
   ```
2. Save the file and run:  
   ```bash
   mvn install
   ```

#### Using Gradle

1. Add the following line to the `dependencies` section in your `build.gradle` file:  
   ```gradle
    implementation 'org.asynchttpclient:async-http-client:3.0.1'
   ```  
2. Run the following command to fetch the dependency:  
   ```bash
   gradle build
   ```

### 3. Run the Generated Code

After setting up Java and adding the `AsyncHttpClient` library, follow these steps to execute the generated code:  

1. **Create a new Java file**: Save the generated code into a file with a `.java` extension, such as `ApiTest.java`.  
2. **Compile the file**: Use the following command in the terminal:  
   ```bash
   javac ApiTest.java
   ```  
3. **Run the compiled program**:  
   ```bash
   java ApiTest
   ```

## Java (HttpClient)

Here are the detailed instructions for running the generated API Dash code in **Java (using `HttpClient`)** for macOS, Windows, and Linux:

### 1. Install Java

To run Java code, you need to have Java Development Kit (JDK) installed on your system.

- Visit the official **[Java Downloads Page](https://www.oracle.com/in/java/technologies/downloads/#jdk23)** and follow the instructions to install the latest JDK on macOS, Windows, or Linux.

After installation, verify it by running:

```bash
java -version
```

### 2. `HttpClient` Setup

The `HttpClient` library is included as part of the **Java SE 11** (or later) standard library.  
- Ensure you have **Java 11** or a later version installed to use `HttpClient` without needing additional dependencies.

To confirm your Java version, run:  
```bash
java -version
```  

### 3. Run the Generated Code

After setting up Java and checking the version, follow these steps to execute the generated code:  

1. **Create a new Java file**: Save the generated code into a file with a `.java` extension, such as `ApiTest.java`.  
2. **Compile the file**: Use the following command in the terminal:  
   ```bash
   javac ApiTest.java
   ```  
3. **Run the compiled program**:  
   ```bash
   java ApiTest
   ```

## Java (okhttp3)

Here are the detailed instructions for running the generated API Dash code in **Java (using `okhttp3`)** for macOS, Windows, and Linux:

### 1. Install Java

To run Java code, you need to have Java Development Kit (JDK) installed on your system.

- Visit the official **[Java Downloads Page](https://www.oracle.com/in/java/technologies/downloads/#jdk23)** and follow the instructions to install the latest JDK on macOS, Windows, or Linux.

After installation, verify it by running:

```bash
java -version
```

### 2. Add the `okhttp3` Library

To use `okhttp3` in Java, you need to add it as a dependency in your project.  

#### Using Maven

1. Add the following dependency to your `pom.xml` file:  
   ```xml
   <dependency>
       <groupId>com.squareup.okhttp3</groupId>
       <artifactId>okhttp</artifactId>
       <version>4.12.0</version>
   </dependency>
   ```  
2. Save the file and run:  
   ```bash
   mvn install
   ```

#### Using Gradle

1. Add the following line to the `dependencies` section in your `build.gradle` file:  
   ```gradle
   implementation 'com.squareup.okhttp3:okhttp:4.12.0'
   ```  
2. Run the following command to fetch the dependency:  
   ```bash
   gradle build
   ```

### 3. Run the Generated Code

After setting up Java and adding the `okhttp3` library, follow these steps to execute the generated code:  

1. **Create a new Java file**: Save the generated code into a file with a `.java` extension, such as `ApiTest.java`.  
2. **Compile the file**: Use the following command in the terminal:  
   ```bash
   javac ApiTest.java
   ```  
3. **Run the compiled program**:  
   ```bash
   java ApiTest
   ```

## Java (Unirest)

Here are the detailed instructions for running the generated API Dash code in **Java (using `Unirest`)** for macOS, Windows, and Linux:

### 1. Install Java

To run Java code, you need to have Java Development Kit (JDK) installed on your system.

- Visit the official **[Java Downloads Page](https://www.oracle.com/in/java/technologies/downloads/#jdk23)** and follow the instructions to install the latest JDK on macOS, Windows, or Linux.

After installation, verify it by running:

```bash
java -version
```

### 2. Add the `Unirest` Library

To use `Unirest` in Java, you need to add it as a dependency in your project.  

#### Using Maven

1. Add the following dependency to your `pom.xml` file:  
   ```xml
   <dependency>
       <groupId>com.konghq</groupId>
       <artifactId>unirest-java</artifactId>
       <version>3.14.1</version>
   </dependency>
   ```  
2. Save the file and run:  
   ```bash
   mvn install
   ```

#### Using Gradle

1. Add the following line to the `dependencies` section in your `build.gradle` file:  
   ```gradle
   implementation 'com.konghq:unirest-java:3.14.1'
   ```  
2. Run the following command to fetch the dependency:  
   ```bash
   gradle build
   ```

### 3. Run the Generated Code

After setting up Java and adding the `Unirest` library, follow these steps to execute the generated code:  

1. **Create a new Java file**: Save the generated code into a file with a `.java` extension, such as `ApiTest.java`.  
2. **Compile the file**: Use the following command in the terminal:  
   ```bash
   javac ApiTest.java
   ```  
3. **Run the compiled program**:  
   ```bash
   java ApiTest
   ```

## Julia (HTTP)

Here are the detailed instructions for running the generated API Dash code in **Julia (using `HTTP.jl`)** for macOS, Windows, and Linux:

### 1. Install Julia

#### macOS and Windows:
1. Visit the official **[Julia Downloads Page](https://julialang.org/downloads/)**.
2. Download the installer for your operating system.
3. Run the installer and follow the installation instructions.

#### Linux:
1. Visit the **[Julia Downloads Page](https://julialang.org/downloads/)** or use your package manager:
   - **Ubuntu/Debian**:
     ```bash
     sudo apt update
     sudo apt install julia
     ```
   - **Fedora**:
     ```bash
     sudo dnf install julia
     ```
   - **Arch Linux**:
     ```bash
     sudo pacman -S julia
     ```

2. Verify the installation:
   ```bash
   julia --version
   ```

### 2. Install the HTTP.jl Package

Julia uses a built-in package manager. To install the `HTTP` package:

1. **Start Julia REPL** by typing `julia` in your terminal.
2. **Enter package mode** by pressing `]` (the prompt will change from `julia>` to `pkg>`).
3. **Install HTTP.jl**:
   ```julia
   add HTTP
   ```
4. **Exit package mode** by pressing backspace or Ctrl+C.
5. **Exit Julia REPL** by typing `exit()` or pressing Ctrl+D.

Alternatively, you can install it from a script:
```julia
using Pkg
Pkg.add("HTTP")
```

### 3. Execute the Generated Code

Once you have Julia and the `HTTP` package installed, follow these steps to execute the generated code:

1. **Create a new Julia file**: Save the generated code into a file with a `.jl` extension, such as `api_test.jl`.
2. **Open a terminal** and navigate to the directory containing the file.
3. **Run the Julia script**:
   ```bash
   julia api_test.jl
   ```

#### Alternative: Using Julia REPL
1. Start Julia REPL by typing `julia` in the terminal.
2. Include and run the file:
   ```julia
   include("api_test.jl")
   ```

#### Using Julia in VS Code
1. Install the **Julia extension** for Visual Studio Code.
2. Open your `.jl` file.
3. Press `Ctrl+Enter` (or `Cmd+Enter` on macOS) to run the code in the integrated Julia REPL.

## Kotlin (okhttp3)

Here are the detailed instructions for running the generated API Dash code in Kotlin (using okhttp3) for macOS, Windows, and Linux:

### 1. Install Kotlin

To run Kotlin code, you need to install Kotlin by following the below instructions:

- Go to [Kotlin Installation Guide](https://kotlinlang.org/docs/getting-started.html#install-kotlin) for detailed steps.
- Kotlin is also included in IntelliJ IDEA and Android Studio. You can also download and install one of these IDEs to start using Kotlin. 

### 2. Add `okhttp` library

To use `okhttp3` in your Kotlin project, you need to include it as a dependency. If you're using **Gradle**, follow these steps:

- Open the `build.gradle` file in your project.
- Add the following dependency in the `dependencies` section:

```gradle
implementation("com.squareup.okhttp3:okhttp:4.12.0")
```

- Sync your project to apply the dependency.

### 3. Execute the generated code

After setting up Kotlin and `okhttp3`, follow these steps to run the generated code:

#### Using IDE

1. Open the installed IDE like Android Studio.
2. Create a new Kotlin file.
3. Copy the generated code from API Dash and paste it in the Kotlin file.
4. Run the Kotlin file by clicking the `Run` button in the IDE or by using the command line.

#### Using command line

1. Create a new Kotlin file.
2. Copy the generated code from API Dash and paste it in the Kotlin file (`api_test.kt`).
3. Navigate to the project directory using the terminal or command prompt.
4. Compile and run the Kotlin file by executing:

```bash
kotlinc api_test.kt -include-runtime -d api_test.jar
java -jar api_test.jar
```

## PHP (curl)

Here are the detailed instructions for running the generated API Dash code in PHP (using `curl`) for macOS, Windows, and Linux:

### 1. Install and set PHP:
Before starting out, we need to install PHP in our system. 
#### macOS:
- Go to the official PHP website: [https://www.php.net/manual/en/install.macosx.php](https://www.php.net/manual/en/install.macosx.php)
- Follow the installation instructions.

#### Windows:
- Go to the official PHP website: [https://www.php.net/manual/en/install.windows.php](https://www.php.net/manual/en/install.windows.php)
- Follow the installation instructions.

#### Linux:
The installation process depends on your Linux distribution. Use the appropriate command below:
- ##### Ubuntu/Debian
```bash
sudo apt update
sudo apt install php php-cli php-curl php-mbstring php-xml php-zip -y
```
- ##### Arch Linux / Manjaro
```bash
sudo pacman -S php php-apache php-cgi php-curl php-mbstring php-xml php-zip
```
- ##### Fedora / CentOS
```bash
- sudo dnf install php php-cli php-curl php-mbstring php-xml php-zip -y
```
- ##### OpenSUSE
```bash
sudo zypper install php php-cli php-curl php-mbstring php-xml php-zip
```

✅ Finally, check that everything works correctly pasting this command in your terminal
```bash
php --version
```

### 2. Check cURL
cURL is usually enabled by default. To check if it's active, run:
```bash
php -m | grep curl
```
and check if it returns **curl** as output

#### If curl is disabled

 1. Open the `php.ini` configuration file. You can find its location by running:
```bash
php --ini
```
 2. Open the file in a text editor/IDE
 3. Find this line
```bash
;extension=curl
```
 4. Remove the semicolon (`;`) at the beginning to enable it:
```bash
extension=curl
```
 5. Save and restart php by using
```bash
sudo systemctl restart apache2  # For Apache
sudo systemctl restart php8.2-fpm  # For PHP-FPM (Nginx)
```

### 3. Execute the generated code:
Once you have everything needed installed, follow these steps to execute the generated code:

1. **Open a IDE/text editor** ✍️ (Visual Studio, VS Code or any other text editor).
2. **Create a php file ( ex. `request.php` )** ✍️ (Visual Studio, VS Code or any other text editor).
3. **Copy and paste the generated API code** 📋 from API Dash into the `request.php` file.

#### In Visual Studio:
1. Click the **Start Debugging `(F5)`** button from the top menu to run the project.
2. The terminal will display the API response.

#### Using the CLI:
 1. Open the terminal at the project root directory and run the file you've created:
   ```bash
   php filename.php
   ```
 2. The terminal will display the API response.

## PHP (guzzle)

Here are the detailed instructions for running the generated API Dash code in PHP (using `Guzzle`) for macOS, Windows, and Linux:

### 1. Install and Set Up PHP

Before starting, you need to install PHP on your system. Follow the instructions from the [PHP (curl)](#php-curl) section above to install PHP for your operating system.

Verify PHP installation:
```bash
php --version
```

### 2. Install Composer

Composer is a dependency manager for PHP. Guzzle is installed via Composer.

#### macOS and Linux:
1. Download and install Composer:
   ```bash
   curl -sS https://getcomposer.org/installer | php
   sudo mv composer.phar /usr/local/bin/composer
   ```

2. Verify installation:
   ```bash
   composer --version
   ```

#### Windows:
1. Download the [Composer Windows Installer](https://getcomposer.org/Composer-Setup.exe).
2. Run the installer and follow the setup wizard.
3. Verify installation in Command Prompt:
   ```bash
   composer --version
   ```

### 3. Install Guzzle

Navigate to your project directory and install Guzzle using Composer:

```bash
composer require guzzlehttp/guzzle
```

This will create a `composer.json` file and a `vendor` directory with Guzzle installed.

### 4. Execute the Generated Code

Once you have PHP, Composer, and Guzzle installed, follow these steps to execute the generated code:

1. **Create a PHP file** (e.g., `api_test.php`).
2. **Copy the generated code** from API Dash and paste it into the file.
3. **Add the Composer autoloader** at the top of your PHP file if not already present:
   ```php
   <?php
   require 'vendor/autoload.php';

   // Your generated API Dash code here
   ```
4. **Save the file**.

### 5. Run the Code

#### Using the CLI:
1. Open the terminal at the project directory.
2. Run the PHP file:
   ```bash
   php api_test.php
   ```
3. The terminal will display the API response.

#### Using an IDE (e.g., VS Code, PhpStorm):
1. Open the project in your IDE.
2. Ensure the PHP interpreter is configured.
3. Run the file using the IDE's run command (e.g., press F5 or use the Run button).
4. The output will be displayed in the IDE's terminal/console.

## PHP (HTTPlug)

Here are the detailed instructions for running the generated API Dash code in PHP (using `HTTPlug`) for macOS, Windows, and Linux:

### 1. Install and Set Up PHP

Before starting, you need to install PHP on your system. Follow the instructions from the [PHP (curl)](#php-curl) section above to install PHP for your operating system.

Verify PHP installation:
```bash
php --version
```

### 2. Install Composer

Composer is a dependency manager for PHP. HTTPlug is installed via Composer.

If you don't have Composer installed, follow the instructions in the [PHP (guzzle)](#2-install-composer) section above.

### 3. Install HTTPlug

HTTPlug is a HTTP client abstraction library. You need to install both HTTPlug and an HTTP client adapter.

Navigate to your project directory and install HTTPlug with a client implementation (e.g., Guzzle adapter):

```bash
composer require php-http/httplug
composer require php-http/guzzle7-adapter
composer require guzzlehttp/psr7
```

Alternatively, you can use cURL adapter:
```bash
composer require php-http/httplug
composer require php-http/curl-client
composer require guzzlehttp/psr7
```

### 4. Execute the Generated Code

Once you have PHP, Composer, and HTTPlug installed, follow these steps to execute the generated code:

1. **Create a PHP file** (e.g., `api_test.php`).
2. **Copy the generated code** from API Dash and paste it into the file.
3. **Add the Composer autoloader** at the top of your PHP file if not already present:
   ```php
   <?php
   require 'vendor/autoload.php';

   // Your generated API Dash code here
   ```
4. **Save the file**.

### 5. Run the Code

#### Using the CLI:
1. Open the terminal at the project directory.
2. Run the PHP file:
   ```bash
   php api_test.php
   ```
3. The terminal will display the API response.

#### Using an IDE (e.g., VS Code, PhpStorm):
1. Open the project in your IDE.
2. Ensure the PHP interpreter is configured.
3. Run the file using the IDE's run command (e.g., press F5 or use the Run button).
4. The output will be displayed in the IDE's terminal/console.

### 6. Additional Information

HTTPlug is a standardized HTTP client interface that allows you to write reusable code independent of the HTTP client implementation. You can switch between different HTTP clients (Guzzle, cURL, Socket, etc.) without changing your application code.

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
  
💡 **[Optional] Recommended: Use a Virtual Environment**

It is recommended to run API Dash generated Python code inside a virtual environment 
to avoid dependency conflicts with other Python projects.

#### Create and activate a virtual environment:

**macOS / Linux**

```bash
python3 -m venv myenv
source myenv/bin/activate
```

**Windows**

```bash
python -m venv myenv
myenv\Scripts\activate
```

After activation, install dependencies:

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

Here are the detailed instructions for running the generated API Dash code in **Ruby (using `Faraday`)** for macOS, Windows, and Linux:

### 1. Install Ruby

#### macOS:
Ruby comes pre-installed on macOS. Verify by running:
```bash
ruby --version
```

For the latest version, you can use Homebrew:
```bash
brew install ruby
```

#### Windows:
1. Download and install Ruby from [RubyInstaller](https://rubyinstaller.org/).
2. During installation, check "Add Ruby executables to your PATH".
3. Verify installation in Command Prompt:
   ```bash
   ruby --version
   ```

#### Linux:
- **Ubuntu/Debian**:
  ```bash
  sudo apt update
  sudo apt install ruby-full
  ```
- **Fedora/CentOS**:
  ```bash
  sudo dnf install ruby
  ```
- **Arch Linux**:
  ```bash
  sudo pacman -S ruby
  ```

Verify installation:
```bash
ruby --version
```

### 2. Install Faraday Gem

Faraday is installed using Ruby's package manager, `gem`.

Install Faraday:
```bash
gem install faraday
```

For projects using Bundler, add to your `Gemfile`:
```ruby
gem 'faraday'
```

Then run:
```bash
bundle install
```

### 3. Execute the Generated Code

Once you have Ruby and Faraday installed, follow these steps to execute the generated code:

1. **Create a Ruby file**: Save the generated code into a file with a `.rb` extension, such as `api_test.rb`.
2. **Open a terminal** and navigate to the directory containing the file.
3. **Run the Ruby script**:
   ```bash
   ruby api_test.rb
   ```

The API response will be displayed in the terminal.

### 4. Using an IDE

#### VS Code:
1. Install the Ruby extension for VS Code.
2. Open your `.rb` file.
3. Run the file using the integrated terminal or the Run button.

#### RubyMine:
1. Open the project in RubyMine.
2. Right-click the Ruby file and select "Run".
3. The output will appear in the Run window.

## Ruby (net/http)

Here are the detailed instructions for running the generated API Dash code in **Ruby (using `net/http`)** for macOS, Windows, and Linux:

### 1. Install Ruby

Follow the instructions from the [Ruby (faraday)](#1-install-ruby) section above to install Ruby for your operating system.

Verify Ruby installation:
```bash
ruby --version
```

### 2. `net/http` is a Built-in Library

`net/http` is part of Ruby's standard library, so no additional installation is required. You can use it directly in your Ruby scripts.

### 3. Execute the Generated Code

Once you have Ruby installed, follow these steps to execute the generated code:

1. **Create a Ruby file**: Save the generated code into a file with a `.rb` extension, such as `api_test.rb`.
2. **Open a terminal** and navigate to the directory containing the file.
3. **Run the Ruby script**:
   ```bash
   ruby api_test.rb
   ```

The API response will be displayed in the terminal.

### 4. Using an IDE

#### VS Code:
1. Install the Ruby extension for VS Code.
2. Open your `.rb` file.
3. Run the file using the integrated terminal or by pressing the Run button.

#### RubyMine:
1. Open the project in RubyMine.
2. Right-click the Ruby file and select "Run".
3. The output will appear in the Run window.

### 5. Additional Tips

- **View detailed output**: You can add debugging to see request/response details by enabling debug mode:
  ```ruby
  require 'net/http'
  Net::HTTP.set_debug_output($stdout)
  ```

- **Handle HTTPS**: For HTTPS requests, you may need to configure SSL:
  ```ruby
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  ```

## Rust (hyper)

Here are the detailed instructions for running the generated API Dash code in **Rust (using `hyper`)** for macOS, Windows, and Linux:

### 1. Download and Install Rust

#### Windows
1. Download and install `rustup` from [Rustup Official Site](https://rustup.rs).
2. Run the installer (`rustup-init.exe`) and follow the instructions.
3. Restart your terminal (Command Prompt or PowerShell).
4. Verify the installation:
   ```sh
   rustc --version
   cargo --version
   ```

#### macOS/Linux
1. Run the following in your terminal:
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   Then follow the on-screen instructions.

2. Restart the terminal and verify:
   ```sh
   rustc --version
   cargo --version
   ```

> Note: If you prefer not to use rustup for some reason, please see the Other [Rust Installation Methods](https://forge.rust-lang.org/infra/other-installation-methods.html) page for more options.

### 2. Set Up a New Rust Project

1. Open a terminal and create a new Rust project:
   ```sh
   cargo new hyper-demo
   ```
2. Navigate into the project directory:
   ```sh
   cd hyper-demo
   ```

   Or open this project directory in your preferred code editor.

### 3. Add Necessary Dependencies

Open the `Cargo.toml` file and add the following dependencies under `[dependencies]`:

```toml
[dependencies]
hyper = { version = "1.1", features = ["full"] }
hyper-util = { version = "0.1", features = ["full"] }
tokio = { version = "1", features = ["full"] }
http-body-util = "0.1"
```

Then run the following command to fetch dependencies:
```sh
cargo build
```

### 4. Execute Code

1. Copy the generated code from API Dash.
2. Paste the code into your project's `src/main.rs` file.

Run the generated code:
```sh
cargo run
```

### 5. Additional Notes

- Hyper is an asynchronous HTTP library, so it requires an async runtime like Tokio.
- Make sure the generated code includes the `#[tokio::main]` attribute on the main function.
- For more advanced usage, refer to the [Hyper documentation](https://docs.rs/hyper/).

## Rust (reqwest)

### 1. Download and Install Rust:

#### **Windows**  
1. Download and install `rustup` from [Rustup Official Site](https://rustup.rs).  
2. Run the installer (`rustup-init.exe`) and follow the instructions.  
3. Restart your terminal (Command Prompt or PowerShell).  
4. Verify the installation:  
   ```sh
   rustc --version
   cargo --version
   ```

#### **MacOS/Linux**
1. Run the following in your terminal:  
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   then follow the on-screen instructions.

2. Restart the terminal and verify:  
   ```sh
   rustc --version
   cargo --version
   ```

> Note: If you prefer not to use rustup for some reason, please see the Other [Rust Installation Methods](https://forge.rust-lang.org/infra/other-installation-methods.html) page for more options.

### 2. Set Up a New Rust Project
1. Open a terminal and create a new Rust project:  
   ```sh
   cargo new reqwest-demo
   ```
2. Navigate into the project directory:  
   ```sh
   cd reqwest-demo
   ```

   or open this project directory in your preferred code editor.

### 3. Add Necessary Dependencies
Run the following command to add dependencies:  
```sh
cargo add reqwest --features blocking,json
cargo add tokio --features full
```
- `"blocking"`: Enables synchronous requests.  
- `"json"`: Allows JSON parsing.  
- `"tokio"`: Needed for asynchronous execution.  

Run the following command to fetch dependencies:  
```sh
cargo build
```

### 4. Execute code
1. Copy the generated code from API Dash.
2. Paste the code into your project's `src/main.rs` directory

Run the generated code: 
```sh
cargo run
```

## Rust (ureq)

### 1. Download and Install Rust:

#### **Windows**  
1. Download and install `rustup` from [Rustup Official Site](https://rustup.rs).  
2. Run the installer (`rustup-init.exe`) and follow the instructions.  
3. Restart your terminal (Command Prompt or PowerShell).  
4. Verify the installation:  
   ```sh
   rustc --version
   cargo --version
   ```

#### **MacOS/Linux**
1. Run the following in your terminal:  
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   then follow the on-screen instructions.

2. Restart the terminal and verify:  
   ```sh
   rustc --version
   cargo --version
   ```

> Note: If you prefer not to use rustup for some reason, please see the Other [Rust Installation Methods](https://forge.rust-lang.org/infra/other-installation-methods.html) page for more options.

### 2. Set Up a New Rust Project
1. Open a terminal and create a new Rust project:  
   ```sh
   cargo new ureq-demo
   ```
2. Navigate into the project directory:  
   ```sh
   cd ureq-demo
   ```

   or open this project directory in your preferred code editor.

### 3. Add `ureq` Dependency

Run the following command to add dependencies:  
```sh
cargo add ureq
``` 
Run the following command to fetch dependencies:  
```sh
cargo build
```

### 4. Execute code
1. Copy the generated code from API Dash.
2. Paste the code into your project's `src/main.rs` directory

Run the generated code: 
```sh
cargo run
```

## Rust (Actix Client)

Here are the detailed instructions for running the generated API Dash code in **Rust (using `Actix Client`)** for macOS, Windows, and Linux:

### 1. Download and Install Rust

#### Windows
1. Download and install `rustup` from [Rustup Official Site](https://rustup.rs).
2. Run the installer (`rustup-init.exe`) and follow the instructions.
3. Restart your terminal (Command Prompt or PowerShell).
4. Verify the installation:
   ```sh
   rustc --version
   cargo --version
   ```

#### macOS/Linux
1. Run the following in your terminal:
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   Then follow the on-screen instructions.

2. Restart the terminal and verify:
   ```sh
   rustc --version
   cargo --version
   ```

> Note: If you prefer not to use rustup for some reason, please see the Other [Rust Installation Methods](https://forge.rust-lang.org/infra/other-installation-methods.html) page for more options.

### 2. Set Up a New Rust Project

1. Open a terminal and create a new Rust project:
   ```sh
   cargo new actix-client-demo
   ```
2. Navigate into the project directory:
   ```sh
   cd actix-client-demo
   ```

   Or open this project directory in your preferred code editor.

### 3. Add Necessary Dependencies

Add the Actix Web client dependencies to your project:

```sh
cargo add awc
cargo add actix-rt
```

Alternatively, you can manually edit `Cargo.toml` and add:

```toml
[dependencies]
awc = "3.5"
actix-rt = "2.10"
```

Run the following command to fetch dependencies:
```sh
cargo build
```

### 4. Execute Code

1. Copy the generated code from API Dash.
2. Paste the code into your project's `src/main.rs` file.

Run the generated code:
```sh
cargo run
```

### 5. Additional Notes

- **awc** (Actix Web Client) is the HTTP client for the Actix ecosystem.
- It requires the Actix runtime (`actix-rt`) to execute asynchronous operations.
- Make sure your `main` function is annotated with `#[actix_rt::main]` for async support.
- For more information, refer to the [Actix Web Client documentation](https://docs.rs/awc/).

## Swift (URLSession)

###  Set Up the Environment
#### MacBook (macOS)

Verify Swift :  
```
swift --version
```


#### Linux(Multipartformdata is not supported)

Download Swift for Linux (e.g., Ubuntu) from Swift.org.

```
tar xzf filename
export PATH=$PWD/filename/usr/bin:$PATH

```
Verify: 
```
swift --version
```





Install Dependencies:
```
sudo apt-get update
sudo apt-get install clang libicu-dev libcurl4-openssl-dev
```


### Create a Project:
```
mkdir URLSessionDemo
cd URLSessionDemo
swift package init --type executable
```




### Run the Code
Ensure main.swift is in Sources/URLSessionDemo.


Run:
```
swift run
```

## Swift (Alamofire)

###  Set Up the Environment
#### MacBook (macOS)

Verify Swift :  
```
swift --version
```


#### Linux (Multipartformdata is not supported)

Download Swift for Linux (e.g., Ubuntu) from Swift.org.

```
tar xzf filename
export PATH=$PWD/filename/usr/bin:$PATH

```
Verify: 
```
swift --version
```





 Install Dependencies for swift:
```
sudo apt-get update
sudo apt-get install clang libicu-dev libcurl4-openssl-dev
```


### Create a Project:
```
mkdir URLSessionDemo
cd URLSessionDemo
swift package init --type executable
```


### Adding alamofire
 open `package.swift` and add following dependencies and target(replace `project-name` with your project name)
```
 dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.6.4")
    ],
 targets: [
        .executableTarget(
            name: "project-name",
            dependencies: [
                "Alamofire" 
            ]
        )
    ]


```



### Run the Code
Ensure main.swift is in Sources/URLSessionDemo.


Run:
```
swift run
```



