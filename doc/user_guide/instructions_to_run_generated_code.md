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

TODO

## JavaScript (axios)

TODO

## JavaScript (fetch)

TODO

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

TODO

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
