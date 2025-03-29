## INITIAL IDEA PROPOSAL

### **CONTACT INFORMATION**

* Name: Udhay Adithya J
* Email: [udhayxd@gmail.com](mailto:udhayxd@gmail.com)
* [Github](https://github.com/Udhay-Adithya)
* [Website](https://udhay-adithya.me)
* [LinkedIn](https://www.linkedin.com/in/udhay-adithya/)
* Location: Amravati, Andhra Pradesh, India, UTC+5:30
* University: Vellore Institute of Technology, Andhra Pradesh
* Major: Computer Science & Engineering
* Degree: Bachelor of Technology
* Year: Sophomore, 2nd Year
* Expected graduation date: 2027


### **PROJECT TITLE: [mem0](https://github.com/mem0ai/mem0) for Dart**

### **PROJECT DESCRIPTION:**

mem0 is the goto memory layer for developing personalized AI Agents in Python. It offers comprehensive memory management, self-improving memory capabilities, cross-platform consistency, and centralized memory control. It leverages advanced LLMs and algorithms to detect, store, and retrieve memories from conversations and interactions. It identifies key information such as facts, user preferences, and other contextual information, smartly updates memories over time by resolving contradictions, and supports the development of an AI Agent that evolves with the user interactions. When needed, mem0 employs a smart search system to find memories, ranking them based on relevance, importance, and recency to ensure only the most useful information is presented.

However, a critical gap exists in the Flutter ecosystem for a dedicated memory layer tailored for AI agent development. Flutter, with its cross-platform capabilities and vibrant community, is increasingly becoming a platform of choice for building mobile and embedded AI applications. 

This project proposes to bridge this gap by porting the powerful [mem0](https://github.com/mem0ai/mem0) library from Python to Dart, thereby making its advanced memory management features accessible to Flutter developers.

### **PROJECT GOALS:**

The primary goal of this project is to create a fully functional Dart port of the `mem0` library.

Upon successful completion of this project, we will have:

*  `mem0_dart` as a standalone package in [pub.dev](https://pub.dev/).
*   Seamless integration of `mem0_dart` into Flutter applications, enabling developers to build personalized AI agents on mobile, web, and desktop platforms.

### **IMPLEMENTATION PROCESS**

Porting `mem0` from Python to Dart is a incremental process and features can be added in a sequence, we have the flexibilty to build block-by-block. 

I have also opened a discussion([#2373](https://github.com/mem0ai/mem0/discussions/2373)) about this in mem0’s GitHub Discussions


**These are some of the packages that are required and will be used in this project:**

**→ LLM and Embedding Support Packages**

- [anthropic_sdk_dart](https://pub.dev/packages/anthropic_sdk_dart)
- [aws_client](https://pub.dev/packages/aws_client)
- [googleai_dart](https://pub.dev/packages/googleai_dart/versions)
- [groq](https://pub.dev/packages/groq)
- [openai_dart](https://pub.dev/packages/openai_dart)
- [ollama_dart](https://pub.dev/packages/ollama_dart)
- [vertex_ai](https://pub.dev/packages/vertex_ai)
- [together_ai_sdk](https://pub.dev/packages/together_ai_sdk)


**→ Vector Store Packages**

- [chromadb](https://pub.dev/packages/chromadb)
- [elastic_client](https://pub.dev/packages/elastic_client)
- [pgvector](https://pub.dev/packages/pgvector)
- [qdrant](https://pub.dev/packages/qdrant)
- [redis](https://pub.dev/packages/redis)

**→ Other packages**

- [http](https://pub.dev/packages/http)/[dio](https://pub.dev/packages/dio)
- [neo4j_http_client](https://pub.dev/packages/neo4j_http_client)
- [huggingface_dart](https://pub.dev/packages/huggingface_dart)
- [posthog_flutter](https://pub.dev/packages/posthog_flutter)


**Note**: The following are some of the packages used in the original `mem0` project that are currently unavailable in the Dart ecosystem. I am actively searching for alternatives, and this list will be updated as suitable replacements are found.  

- **litellm** – N/A  
- **azure-search-documents** – N/A  
- **opensearch** – N/A  
- **milvus** – No direct Dart package, but it can be accessed via HTTP APIs.

### **USAGE**

The `mem0_dart` library will be designed to be intuitive and easy to integrate into Flutter applications. Here's a basic example illustrating its intended usage:

**Initialization:**

```dart
import 'package:mem0_dart/mem0_dart.dart';

void main() async {
  // Initialize Mem0 with default configurations or custom settings
  final memory = Memory(); // Using default configurations

  // Or with custom configurations (example - Qdrant vector store)
  final memoryWithQdrant = Memory(
    vectorStoreConfig: VectorStoreConfig(
      provider: 'qdrant',
      config: {
        'collection_name': 'my_flutter_memories',
        'embedding_model_dims': 1536, // Example dimension
        'path': '/path/to/qdrant/db', // Example path for local Qdrant
      },
    ),
    llmConfig: LlmConfig( // Example - OpenAI LLM for memory processing
      provider: 'openai',
      config: {
        'model': 'gpt-4o-mini',
        'apiKey': 'YOUR_OPENAI_API_KEY',
      },
    ),
    embedderConfig: EmbedderConfig( // Example - OpenAI Embedding model
      provider: 'openai',
      config: {
        'model': 'text-embedding-3-small',
        'apiKey': 'YOUR_OPENAI_API_KEY',
      },
    ),
  );

  // ... rest of your Flutter app code
}
```

**Adding Memories:**

```dart
// ... inside your Flutter widget or logic

  String userMessage = "I love Flutter and Dart!";
  String userId = "flutter_dev_123";

  try {
    final memoryResult = await memory.add(
      messages: userMessage,
      userId: userId,
    );
    print('Memory Added: ${memoryResult}');
  } catch (e) {
    print('Error adding memory: $e');
  }
```

## **MILESTONES AND DELIVERABLES**


I propose to divide the project into four milestones/deliverables to produce a sequential progress report through the GSoC. 

*They are NOT of equal sizes/time* requirements.

#### **Milestone #1: Create a Bare-bone `package: mem0_dart`.**

This milestone will lay the foundation of `mem0_dart` library, porting core configuration classes and setting up testing frameworks.

This milestone will be the first deliverable but it will take the least amount of time and effort to build.

#### **Milestone #2: Vector Store Integrations**

This milestone will integrate and implement multiple Vecotor DB providers available in Dart.

Implementation efforts will concentrate more on the core methods (insert, search, delete, and get).

#### **Milestone #3: LLM and Embedding Model Integration with Basic Functionality**

This Milestone is divided into two parts. The first path will aim at adding integrations for multiple Embedding models.

The second part will add integrations for LLMs and additionally the core memory operations for addition, retrieval, and updating will be ported and tested.

#### **Milestone #4: Add Graph Memory Capabilty**

The final milestone of the project proposes to add Graph memory capabilities by implementing Neo4j integration.

## **[GSOC 2025 TIMELINE](https://developers.google.com/open-source/gsoc/timeline) FOR REFERENCE**


**May 8 - 18:00 UTC**
* Accepted GSoC contributor projects announced

**May 8 - June 1**
* Community Bonding Period | GSoC contributors get to know mentors,
read documentation, and get up to speed to begin working on their
projects

**June 2**
* Coding officially begins!

**July 14 - 18:00 UTC**
* Mentors and GSoC contributors can begin submitting midterm evaluations

**July 18 - 18:00 UTC**
* Midterm evaluation deadline (standard coding period)

**July 14 - August 25**
* Work Period | GSoC contributors work on their project with guidance from Mentors

**August 25 - September 1 - 18:00 UTC**
* Final week: GSoC contributors submit their final work product and
their final mentor evaluation (standard coding period)

## **PREDICTED PROJECT TIMELINE**
* **Community Bonding Period (May 8 - June 1)**

    This is the period where I will get to know my mentors better. I will also ask questions and attempt to clarify the doubts and queries in my mind, to get a clear understanding of the project. Although Google recommends this 3-week bonding period to be entirely for the introduction of GSoC Contributors into their projects, since we are going to build a brand new package, I propose to begin coding from the 2nd or 3rd week of this period, thus adding a headstart.

* **Coding Period (June 2 - July 14)**
    * **Week 1 (June 2 - June 8)**

      <u>M#1 is delivered, comprising of a bare-bones package.</u>
      
      Work on M#2 begins in the latter half of the week.
    * **Week 2 (June 9 - June 15)**

      Integration of first two chosen vector database and implementation of basic vector operations(insert, search, delete, and get) are done, along with unit tests.
      
    * **Week 3 (June 16 - June 22)**
    
      Building upon the previous week, the integration of the other remaining vector databases will be done.

    * **Week 4 (June 16 - June 22)**
    
      Based on the implementation experience and testing feedback from the Vector Database integrations, refinements will be made to ensure robustness and efficiency.

    * **Week 5 (June 23 - June 29)**

      Start of M#3 by integrating OpenAI and Gemini's LLM and embedding models.
      
      This week will also contain steps of documenting the package for initial public release.
      
      Mentor Reviews are requested.

      *`The first public release of package mem0_dart:0.0.1 is made.`*

    * **Week 6 (June 30 - July 6)**

      Changes follow, from Mentor Review, if required.
      
      Add support for other LLM and Embedding model providers(Since the same process has been done earlier this must be fairly easy to implement).
      
      Final Mentor Review before Mid-term Evaluation is submitted.

* **Midterm Evaluation Submission (July 14 - July 18)**
    * Projects are submitted to the mentors and the GSoC portal.

* **Work Period (July 14 - August 25)**
    * **Week 7 (July 14 - July 20)**
      
      A significant portion of the week will be dedicated to testing all integrations thoroughly and addressing any bugs or issues identified.
      
      Documentation is enhanced in the if no issues arise.
      <u>Milestone #3 is delivered.</u>
      
      *`Second public release of package at 0.0.2`*

    * **Week 8 (July 21 - July 27)**

      Classes for graph database connections using Neo4j are created.

    * **Week 9 (July 28 - August 3)**

      Implementation of basic graph operations to store memories as graphs.

    * **Week 10 (August 4 - August 10)**

      Continuation of the work done in Week 9.
      
      Mentor Reviews are requested.

    * **Week 11 (August 11 - August 17)**

      The former half of the week acts as a buffer period in case any issues are confronted.
      
      Documentation is enhanced in the buffer period if no issues arise.

      <u>Milestone #4 is delivered.</u>

      *`Third public release of the package at 0.0.3`*

    * **Week 12 (August 18 - August 24)**

      Final checks are made, and any supporting documents (such as example markdown files) are written.
      
      The project Report is written and all tracking issues are labelled appropriately.
      
* **Final Week (August 25 - September 1)**
    * The final project and the report are submitted to the mentors and on the GSoC portal.
