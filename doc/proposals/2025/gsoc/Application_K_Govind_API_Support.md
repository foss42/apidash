## About  

### Personal Information  
- **Full Name:** K Govind
- **Contact Info:** govindkm20044@gmail.com   Phone with whatsapp no: 9495657944 
- **Discord Handle:** clasherzz. 
- **Home Page:** https://clasherzz.github.io/K_Govind/  (i haven't been able to update the sites with my projects  kindly refer my github profile for projects)
- **GitHub Profile:**  https://github.com/Clasherzz
- **Social Media:**  
  - Twitter: https://x.com/KGovind375917
  - LinkedIn: https://www.linkedin.com/in/k-govind-226529270/
  
- **Time Zone:** Thrissur, KL · UTC+5:30 (IST)
- **Resume:** https://drive.google.com/drive/folders/1nHlF1_uSjGRc-DruOZaVZeZT-MF8FBVh?usp=sharing
   

---

## University Info  

- **University Name:** Government Engineering College Thrissur 
- **Program:** Btech in computer Science 
- **Year:** 3rd Year
- **Expected Graduation Date:** May 2026

---

## Motivation & Past Experience  

### Open Source Contributions  
- My open source journey started from APIDash itself. I discovered it towards the end of last year and became a regular user of it.
  - **Repo Links/PRs:**
      - Adding codegen for hyper-rust (https://github.com/foss42/apidash/pull/468) :- I thought this to be a comparitively easy contribution when i started but became challenging when i encountered with lack of multipart functionaility in the package. I made some mistakable commits since it was first PR but with all that happened was still able to make a quality PR
      - SSL Feature (https://github.com/foss42/apidash/pull/512) :- I came across this issue first while testing the hyper codegen i made. I took notice of the issue and when came to learn that the feauture was not in apidash took initiative to make it happen.
      - Client running in background problem even after removal (https://github.com/foss42/apidash/pull/560) ;- A small bug that came across me while using the app.
      - Multipart cancellation error and Request cancellation flow Error :- Both of these bugs came acorss me while trying to implement the web socket protocol in the app.

### Proud Project/Achievement  
- **Project Name:** EKO is a combination of reselling and recycling platforms for electric components which connects the technicians with the common public.The project gave us Kerela state level winner title in the prestigious YIP Programme. This was one of the first applications that i have coded.
- **Why it matters:** Upon uploading the IMEI No(if component has it) ,model no and model name. Using gemini api we produce all the components inside the phone ,computer etc(using gemini api).The data is then stored . Technicians can now search the components seperately and can purchase the component they want. Rather than scraping (were valuable components are lost) this is a better way to go forward. The consumers get the maximum value price for each of their working components. Imagine your phone is lagging due to overuse.The app comes to help you to sell your undamaged screen , phone speaker etc. The application also had computer vision to recognize electric components lying around your house to know how much it is worth.
- **Repo/Link:** Frontend: https://github.com/Apollo-Blaze/Ekov1
                  Backend: https://github.com/Clasherzz/eko

### Motivating Challenges  
- I like challenges of two kind, one which demands me to think and implement what i learned. And the other  one  which makes me learn new things.

### Availability for GSoC  
- **Will you work full-time on GSoC?** No  
- **If not, what else will you be working on?** I currently have to meet with my study requirements and have to continue my Btech course. My initial plan is to contribute 2 hours per week day and 5 hours in weekend days which i beleive is enough for achieving the proposals goal.
   

### Communication & Sync-ups  
- **Do you mind regularly syncing up with mentors?** I am totally fine with syncing up with mentors for being uptodated on my work and for feedbacks. If its a virtual meet it would be great to have a heads up about the time.  

### Interest in API Dash  
- **What interests you about API Dash?**
 What fascinates me most about APIDash is its elegant Flutter architecture,vibrant community, and its codebase. Despite standing humbly among industry giants, APIDash holds its ground with a well-structured, easy-to-understand codebase that helped me understand how code must be written for a complicated application. The clarity and separation in its design make it a pleasure to explore and contribute to.Apart from that by contributing and going through open issues I was abl to understand a lot of backend concepts.While it may be an underdog today, I have no doubt that it will grow into a formidable contender in the future. I look forward to contributing more features and supporting others along the way!

- **Areas for improvement:** I feel like the application would fullfill its goal as it reaches into wider audience of api testers . And for that the application has to tend to broader needs of api testers.Currently APIDash supports on REST APIs and GRAPHQL in its work flow. It would be great to add in other protocols into the app.

---
 ### API Testing Support 
I would like to introduce some feautures as listed below to enhance the api testing support of the application.All this abstracts are part of a single proposal.


### Web Socket Implementation (Issue Number: #15)
Introducing web socket implementation into the APIDash. Introduce a new client and manager to handle the websocket messages and render them in the ui . 

The solution involves providing the users with an option to change ping intervals, number of reconnection attempts, interval between reconnection attenpts. All of this would be managed inside the settings. The ui updates would be made using riverpod provider specifically for websocket messages for each request ids.Finally during onError and onDone the frames are added into the websocket Response Model. All this would be initiated by user clicking on the new APIType (Web Socket). The appropriate changes would be done in codegen related files to give code. 
In the proposed approach I am using a web Socket Client Manager similar to the Http Manger to not conflict with the existing services.

Operations on incoming messages:
-Upon the incoming messages we can delete specific ones or whole. 
-We can also search for keywords withing every message. Which would be highlightned.(Not Submitted in POC)

I have tested my approach on custom endpoints https://github.com/Clasherzz/testing/blob/main/websock.js , echo websocket and multiple fast incoming web socket message endpoints related to bit coin and stock prices to ensure robustness.
Architecture is as shown below:
  ```  
     +--------------------------------+
|      WebSocket Server         |
|  - Manages connections        |
|  - Handles messages           |
+---------------+--------------+
               |
               v
+--------------------------------------+
|   Settings Connection Manager       |
|  - Ping interval handling           |
|  - Reconnection attempts            |
|  - Interval between retries         |
+----------------+-------------------+
               |
               v
+---------------------------------------------------------------+
|  WebSocket Client (web_socket_channel)                        |
|  - Establishes connection                                     |
|  - Sends & receives messages                                  |
|  - Handles ping & retries                                     |
|  - onError  → Updates Riverpod WebSocket Response Model State |
|              → Saves event history in HistoryModel Provider   |
|  - onListen → Updates WebSocket Messages Provider             |
|  - onDone   → Updates Riverpod WebSocket Response Model State |
|              → Saves event history in HistoryModel Provider   |
+----------------------+----------------------+----------------+
                       |                      |
                       |                      |
+------------------------------------+  +--------------------------------+
|  WebSocket Messages Riverpod       |  |  Riverpod State Management    |
|  Provider                          |  |  - Stores all messages        |
|  - Stores incoming messages        |  |  - Updates WebSocket Model    |
|  - Groups messages by request ID   |  |  - Handles UI reactivity      |
|  - Provides real-time updates      |  +--------------------------------+
+------------------------------------+      |
                       |                     |
                       v                     |
+------------------------------------------------+
|  HistoryModel Provider                         |
|  - Saves event history upon errors (`onError`)|
|  - Saves event history when done (`onDone`)   |
|  - Stores event metadata & timestamps         |
|  - Persists disconnected session logs         |
+------------------------------------------------+
                       |
                       v
+-----------------------------------------+
|        Flutter WebSocket UI            |
|  - Search messages                     |
|  - Clear all/one message               |
|  - Scroll to top/up option             |
|  - Dynamic UI per request              |
|  - View WebSocket Message History      |
+-----------------------------------------+    
  
```

  
- **Technologies & Tools:** The approach uses the package  web_socket_channel(^3.0.1).(https://fluttergems.dev/packages/web_socket_channel/).Supports all platforms.
- **Expected Outcomes:** A clean ui with maximum smoothness satisfying above mentioned solutions.
- **Linked PR for POC:**  https://github.com/foss42/apidash/pull/555  (The PR is in no way the final product but simply to show the code structure and my approach)
  ![Alt text](./images/websocket(1).png)
  ![Alt text](./images/websocket(2).png)


### SSE Support(Issue Number #116)
Implementation fo server send events in the Apidash.

Trying to implement SSE Support into the application. Using a special provider for incoming frames just like in web socket messages . Now the incoming messages would be parsed and decided if it is comment ,data,event,id,retry. Data is the most important one that is needed to be shown. Often comments , id , retry are hidden away. We can provide an option for advanced visibily in settings that helps the developer to see these frames if they want. This can enhance their testing.

The apiType uses the Http Client Manager itself but generates a streamed reponse and listens into it.Inorder to get the actual request headers send by the client i had to use the http_interceptopr package(https://pub.dev/packages/http_interceptor). 

My approach was tested on a https://sse.dev/test

Architecture is as shown below:
```
               +--------------------------------+
                |       SSE Server               |
                |  - Manages connections        |
                |  - Sends event streams        |
                +---------------+--------------+
                                |
                                v
            +--------------------------------------+
            |   Settings Connection Manager       |
            |  - Handles retry intervals         |
            |  - Manages reconnections           |
            |  - Configures event listeners      |
            |  - (Optional) Show Advanced Options|
            |     - Comments                     |
            |     - ID                           |
            |     - Retry Interval               |
            +----------------+-------------------+
                                |
                                v
     +-------------------------------------------------------------------+
     |  SSE Client (http package / eventsource)                          |
     |  - Establishes connection                                         |
     |  - Listens for events                                             |
     |  - Handles automatic reconnections                               |
     |  - onError  → Updates Riverpod SSE Response Model State          |
     |              → Saves event history in HistoryModel Provider      |
     |  - onEvent  → Updates SSE Messages Provider                      |
     |  - onDone   → Updates Riverpod SSE Response Model State          |
     |              → Saves event history in HistoryModel Provider      |
     |  - **HTTP Interceptor** (Inside SSE Client)                       |
     +----------------------+----------------------+--------------------+
                            |                      | 
                            |                      | 
   +------------------------------------+  +--------------------------------+
   |  SSE Messages Riverpod Provider    |  |  Riverpod State Management    |
   |  - Stores incoming messages        |  |  - Stores all messages        |
   |  - Groups messages by event ID     |  |  - Updates SSE Model          |
   |  - Provides real-time updates      |  |  - Handles UI reactivity      |
   +------------------------------------+  +--------------------------------+
                            |                      |
                            |                      |
   +------------------------------------------------+
   |  HistoryModel Provider                         |
   |  - Saves event history upon errors (`onError`)|
   |  - Saves event history when done (`onDone`)   |
   |  - Stores event metadata & timestamps         |
   |  - Persists disconnected session logs         |
   +------------------------------------------------+
                            |
                            v
          +-----------------------------------------+
          |        Flutter SSE UI                   |
          |  - Search messages                     |
          |  - Clear all/one message               |
          |  - Scroll to top/up option             |
          |  - Dynamic UI per event type           |
          |  - View Event History                  |
          +-----------------------------------------+

```
POC Link: https://github.com/foss42/apidash/pull/757
Images of POC: 
![SSE](./images/SSE(1).png)
![SSE](./images/SSE(1).png)



### GraphQL Enhancement
Proposing to include graphql variable support and graphql introspection .

Graphql variable(Issue no #576) :- 

UI Changes:Make a json editor pane as an additional tab in request pane for graphql with enviornment support. 
Service changes: And then parse it along the body of request.

The approach was verified in custom endpoint and in https://rickandmortyapi.com/graphql . A partial implementation of this was done in  https://github.com/foss42/apidash/pull/588   with a mistake in ui approach which would be rectified.


GraphQL Inspect Schema :- The approach is to use a prebuild introspection query that  asks for all the contents necessary that developer would want to know and display the results in GraphQL SDL (Schema Definition Language) . The introspection query asks for all schema details mutation ,subscription, query schema types , directives . Later on we iterate through the received json making the GRAPHQL SDL.
The introspection query would be:
```
{
  __schema {
    queryType {
      name
      fields {
        name
        description
        args {
          name
          description
          type {
            name
            kind
          }
        }
        type {
          name
          kind
        }
      }
    }
    mutationType {
      name
      fields {
        name
        description
        args {
          name
          description
          type {
            name
            kind
          }
        }
        type {
          name
          kind
        }
      }
    }
    subscriptionType {
      name
      fields {
        name
        description
        args {
          name
          description
          type {
            name
            kind
          }
        }
        type {
          name
          kind
        }
      }
    }
    types {
      name
      kind
      description
      fields {
        name
        description
        type {
          name
          kind
        }
      }
    }
    directives {
      name
      description
      locations
      args {
        name
        description
        type {
          name
          kind
        }
      }
    }
  }
}

```
Afterwards if possible i would like to make a package similar to json explorer to render the ui with collapse and expand feauture . This would require some time as SDL is quite different from the standard JSON.


### URL Encoded Multipart(Issue $337):-
Sending MultiPart through the body with x-www-form-urlencoded content type.

Ui change: There would be a toggle button in multipart tab that can switch between multipart and urlencoded multipart . 

Request model change: An additional content type (application/x-www-form-urlencoded). By default the choice would be url encoded multipart content type and would only change to multipart if toggle button is used or if a file is uploaded and selected to send.

Service level change:- We would make key value pairs as string . This is encoded and passes into the body along with added header .

### File support(Issue #352):-
Sending Files through octect-stream content type. 

UI Changes: Make a combination of drag and droppable and select file ui as a new tab. Make a progression bar to show the conversion to bytes progress.
To acheive the droppable interface we can use desktop_drop(https://fluttergems.dev/packages/desktop_drop/)(supports windows,linux,macos,android,web).This works along with already existing file_selector.But it doesn't support IOS.
To support IOS we would have to use super_drag_and_drop(https://fluttergems.dev/packages/super_drag_and_drop/) . Currently I have only been able to test the feauture in windows ,android using desktop_drop.

Model changes: Add another content type application/octet-stream .

Service changes:We pick the file using file_selector. And adds the filepath into the body. Then stream the content to bytes whenever we need to send the file. Showing and handling error appropriately if file is not present or corrupted. 

Put Content-Type header as application/octet-stream and send the request.

### Basic Authentication (Issue Number #610)
This would be a straightforward implementation. We take the input password and username and follow the below said transformation.
 ```                    
+--------------------------------------------------+
| 1. Client combines them into one string         |
|    Format: username:password                     |
|    Example: admin:pass123                        |
+--------------------------------------------------+
                      |
                      v
+--------------------------------------------------+
| 2.Client encodes the string using Base64         |
|    Result: YWRtaW46cGFzczEyMw==                  |
+--------------------------------------------------+
                      |
                      v
+--------------------------------------------------+
| 3. Client adds Authorization header              |
|    Format: Authorization: Basic <Base64String>   |
|    Example: Authorization: Basic YWRtaW46...     |
+--------------------------------------------------+
      
```
### API Key authentication.
UI:Upon selecting AuthType as APIKey there would be a text field for entering APIKey and a sliding button to select whther it should be send through header(X-API-Type) or 
via query parameter. 

Then the transformation occurs depending on the selection.

### Bearer Token authentication:
UI: There would be a text field to enter the bearer token.

The value is added to the Authorization header in the format by the client:
  Bearer <token_value>


### Weekly Timeline  

#### **Week 1:**  
- Getting to know about the organization and what mentors wants to say about the work I am about to start. Fix the timings of meetings if there are any. Get to know which time do the maintainers be more active and share the approach and queries with them.
- Changing the design and architecture from feedback.
- Add the ui for graphql variables feauture. Change service layer to accomodate the change.

#### **Week 2:**
- Make additional endpoints to test the graphql variable feauture and test it on them. Make related test files for this feauture.
- Work on graphql introspection query and on its transformation to GraphqlSDL.
- Add the ui for the inspect Schema.
- Work on the endpoints if needed and test files of this feauture.
- Work on the feauture and do improvements if the testing is causing issues.

#### **Week 3:** 
- Start working on the initial ui.
- update settings providers for the new feautures of Web Socket (number of reconnection attemps, time interval between number of reconnection attempt,ping interval).
- Add service layer of web sockets(Like adding the functions to listen  , catching the error and cancellation)
- Make ui changes to reflect the incoming and outgoing messages.

#### **Week 4:** 
- Add Searching through the messages feauture.
- Work on handling the web socket history.
- Make endpoints to test the feauture. And add the ui and service level tests.
- Work on the feauture and do improvements if the testing is causing issues.

#### **Week 5:** 
- Start working on the initial ui and set update settings providers for the new feautures of SSE.
- Add service layer of SSE.(add functions to listen , handle error etc).
- Make ui for incoming frames.

#### **Week 6:** 
- Add Searching through the frames feauture.
- Work on handling the SSE history.
- Make custom endpoints to test the feauture if organization wants it. And add the ui and service level tests.
- Work on the feauture and do improvements if the testing is causing issues.
 

#### **Week 7-8:** 
- Make way for codegen feautures of sse and WebSocket.
- Work on UI changes for url encoded multipart and make service layer changes to accomadate that.
- Add testing for the ui changes.
- Make endpoints for this feauture if needed and test it upon it generating needed test files.


#### **Week 9**  
- Work on UI changes of File Request and implement the service layer changes.
- Add test files to this After testing thoroughly on major file types coming in different file sizes.

### **Week 10**:
- Make UI changes for Bearer Token.
- Make service level changes needed for it.
- Write test files for this feautre.
- Make UI changes for API Authentication 
- Make service level changes for this and write needed test files.


#### **Week 11**: 
- Make UI changes for Basic Authentication.
- Make service level changes needed for it.
- Write test files for this feautre.
- Final polishing done for any feauture is done if needed.  

#### **Week 12:**  
- Adding needed docmentations.
- Submitting the final documentation and work.

---

