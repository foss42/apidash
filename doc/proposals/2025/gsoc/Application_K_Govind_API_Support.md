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
- **Resume:** [Publicly accessible link to resume]  

---

## University Info  

- **University Name:** Government Engineering College Thrissur 
- **Program:** Btech in computer Science 
- **Year:** 3rd Year
- **Expected Graduation Date:** May 2026

---

## Motivation & Past Experience  

### Open Source Contributions  
- My open source journey started from APIDash itself. I discovered it ast year and became a regular user of it.
  - **Repo Links/PRs:**
      - Adding codegen for hyper-rust (https://github.com/foss42/apidash/pull/468) :- I thought this to be a comparitively easy contribution when i started but became challenging when i encountered with lack of multipart functionaility in the package. I made some mistakable commits since it was first PR but with all that happened was still able to make a quality PR
      - SSL Feature (https://github.com/foss42/apidash/pull/512) :- I came across this issue first while testing the hyper codegen i made. I took notice of the issue and when came to learn that the feauture was not in apidash took initiative to make it happen.
      - Client running in background problem even after removal (https://github.com/foss42/apidash/pull/560) ;- A small bug that came across me while using the app.
      - Multipart cancellation error and Request cancellation flow Error :- Both of these errors came acorss me while trying to implement the web socket protocol in the app.

### Proud Project/Achievement  
- **Project Name:** [Project Title]  
- **Why it matters:** [Brief Explanation]  
- **Repo/Link:** [Link to Project]  

### Motivating Challenges  
- I like challenges of two kind, one which demands me to think and implement what i learned. And the other  one  which makes me learn new things.

### Availability for GSoC  
- **Will you work full-time on GSoC?** No  
- **If not, what else will you be working on?** I currently have to meet with my study requirements and have to continue my Btech course. My initial plan is to contribute 2 hours per week days and 5 hours in weekend days which i beleive is enough for achieving the proposals goal.
   

### Communication & Sync-ups  
- **Do you mind regularly syncing up with mentors?** I am totally fine with syncing up with mentors for being uptodated on my work and for feedbacks. If its a virtual meet it would be great to have a heads up about the time.  

### Interest in API Dash  
- **What interests you about API Dash?** 
- **Areas for improvement:** I feel like the application would fullfill its goal as it reaches into wider audience of api testers . And for that the application has to tend to broader needs of api testers.Currently APIDash supports on REST APIs and GRAPHQL in its work flow. It would be great to add in other protocols into the app.

---



 
### API Testing Support 
I would like to introduce some feautures as listed below to enhance the api testing support of the application. This is part of a single proposal.


### Abstract  1(Web Socket Implementation)
Introducing web socket implementation into the APIDash. Introduce a new client and manager to handle the websocket messages and render them in the ui . 
The solution involves providing the users with an option to change ping intervals, number of reconnection attempts, interval between reconnection attenpts. All of this would be managed inside the settings. The ui updates would be made using river pod provider specifically for websocket messages for each request ids. All this would be initiated by user clicking on the new APIType (Web Socket). The appropriate changes would be done in codegen related files to give code. 
  ```  
            
            +-------------------------+
            |     WebSocket Server     |
            |  - Manages connections   |
            |  - Handles messages      |
            +-----------+-------------+
                        |
                        v
     +------------------------------------+
     |  WebSocket Client (web_socket_channel) |
     |  - Establishes connection          |
     |  - Sends & receives messages       |
     |  - Handles ping & retries          |
     |  - onError → Update Riverpod state |
     |  - onDone  → Update Riverpod state |
     +------------------------------------+
                        |
                        v
        +-------------------------------+
        | WebSocket Connection Manager  |
        |  - Ping interval handling     |
        |  - Reconnection attempts      |
        |  - Interval between retries   |
        +-------------------------------+
                        |
                        v
          +-----------------------------+
          | Riverpod State Management   |
          |  - Stores all messages      |
          |  - Updates WebSocket Model  |
          |  - Handles UI reactivity    |
          +-----------------------------+
                        |
                        v
         +--------------------------------+
         | Flutter WebSocket UI          |
         |  - Search messages            |
         |  - Clear all/one message      |
         |  - Scroll to top/up option    |
         |  - Dynamic UI per request     |
         +--------------------------------+
```

  
- **Technologies & Tools:** The approach uses the package  web_socket_channel(^3.0.1)
- **Expected Outcomes:** A clean ui with maximum smoothness satisfying above mentioned solutions.
- **Linked PR for POC:**  https://github.com/foss42/apidash/pull/555  (The PR is in no way the final product but simply to show the code structure and my approach)

### Abstract 2(SSE Support)
Trying to implement SSE Support into the application. The approach is similar to web_sockets in many ways.



### Abstract 3(GraphQL Enhancement)
Proposing to include graphql variable support and graphql introspection .

Graphql variable :- Make a json editor pane as an additional tab in request pane for graphql with enviornment support. And then parse it along the body of request. The approach was verified in custom endpoint and in https://rickandmortyapi.com/graphql . A partial implementation of this was done in  https://github.com/foss42/apidash/pull/588   with a mistake in ui approach which would be rectified.


GraphQL Introspection :- The approach is to use a prebuild introspection query that  asks for all the contents necessary that developer would want to know and display the results in GraphQL SDL (Schema Definition Language) . The introspection query asks for all schema details mutation ,subscription, query schema types , directives . Later on we iterate through the received json making the GRAPHQL SDL.
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


### Abstract 4(URL Encoded Multipart nd File Support)











### Weekly Timeline  

#### **Week 1-2:**  
- [Task 1]  
- [Task 2]  
- [Task 3]  

#### **Week 3-4:**  
- [Task 1]  
- [Task 2]  
- [Task 3]  

#### **Week 5-6:**  
- [Task 1]  
- [Task 2]  
- [Task 3]  

#### **Week 7-8:**  
- [Task 1]  
- [Task 2]  
- [Task 3]  

#### **Week 9-10:**  
- [Task 1]  
- [Task 2]  
- [Task 3]  

#### **Week 11-12:**  
- [Finalizing & Testing]  
- [Documentation]  
- [Submission]  

---

This structure provides clear formatting and proper indentation in Markdown for easy readability. Let me know if you need any refinements!

