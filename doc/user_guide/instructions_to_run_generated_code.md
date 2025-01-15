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

TODO

## Dart (dio)

TODO

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

Here are the detailed instructions for running the generated API Dash code in **Java (using `AsyncHttpClient`)** for macOS, Windows, and Linux:

---

### **1. Install Java**  
To run Java code, you need to have Java Development Kit (JDK) installed on your system.  

- Visit the official **[Java Downloads Page](https://www.oracle.com/in/java/technologies/downloads/#jdk23)** and follow the instructions to install the latest JDK on macOS, Windows, or Linux.  

After installation, verify it by running:  
```bash
java -version
```

---

### **2. Add the `AsyncHttpClient` Library**  
To use the `AsyncHttpClient` library in Java, you need to add it as a dependency in your project.  

#### Using **Maven**:  
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
3. Save the file and run:  
   ```bash
   mvn install
   ```

#### Using **Gradle**:  
1. Add the following line to the `dependencies` section in your `build.gradle` file:  
   ```gradle
    implementation 'org.asynchttpclient:async-http-client:3.0.1'
   ```  
2. Run the following command to fetch the dependency:  
   ```bash
   gradle build
   ```

---

### **3. Run the Generated Code**  
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

---

## Java (HttpClient)

Here are the detailed instructions for running the generated API Dash code in **Java (using `HttpClient`)** for macOS, Windows, and Linux:

---

### **1. Install Java**  
👉 Follow the instructions provided above under **Java (AsyncHttpClient)** for detailed steps on how to install the Java Development Kit (JDK) on macOS, Windows, or Linux.  

---

### **2. `HttpClient` Setup**  
The `HttpClient` library is included as part of the **Java SE 11** (or later) standard library.  
- Ensure you have **Java 11** or a later version installed to use `HttpClient` without needing additional dependencies.
   

To confirm your Java version, run:  
```bash
java -version
```  
---

### **3. Run the Generated Code**  
👉 Refer to the instructions above under **Java (AsyncHttpClient)** for steps to save, compile, and execute the Java code.  

---

## Java (okhttp3)

Here are the detailed instructions for running the generated API Dash code in **Java (using `okhttp3`)** for macOS, Windows, and Linux:

---

### **1. Install Java**  
👉 Follow the instructions provided above under **Java (AsyncHttpClient)** for detailed steps on how to install the Java Development Kit (JDK) on macOS, Windows, or Linux.

---

### **2. Add the `okhttp3` Library**  
To use `okhttp3` in Java, you need to add it as a dependency in your project.  

#### Using **Maven**:  
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

#### Using **Gradle**:  
1. Add the following line to the `dependencies` section in your `build.gradle` file:  
   ```gradle
   implementation 'com.squareup.okhttp3:okhttp:4.12.0'
   ```  
2. Run the following command to fetch the dependency:  
   ```bash
   gradle build
   ```

---

### **3. Run the Generated Code**  
👉 Refer to the instructions provided above under **Java (AsyncHttpClient)** for steps to save, compile, and execute the Java code.

---

## Java (Unirest)

Here are the detailed instructions for running the generated API Dash code in **Java (using `Unirest`)** for macOS, Windows, and Linux:

---

### **1. Install Java**  
👉 Follow the instructions provided above under **Java (AsyncHttpClient)** for detailed steps on how to install the Java Development Kit (JDK) on macOS, Windows, or Linux.

---

### **2. Add the `Unirest` Library**  
To use `Unirest` in Java, you need to add it as a dependency in your project.  

#### Using **Maven**:  
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

#### Using **Gradle**:  
1. Add the following line to the `dependencies` section in your `build.gradle` file:  
   ```gradle
   implementation 'com.konghq:unirest-java:3.14.1'
   ```  
2. Run the following command to fetch the dependency:  
   ```bash
   gradle build
   ```

---

### **3. Run the Generated Code**  
👉 Refer to the instructions provided above under **Java (AsyncHttpClient)** for steps to save, compile, and execute the Java code.

---

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

TODO

## Python (http.client)

TODO

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
