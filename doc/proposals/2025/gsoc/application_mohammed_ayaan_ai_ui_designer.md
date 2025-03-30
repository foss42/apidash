### About

1. Full Name - Mohammed Ayaan
2. Contact info (email, phone, etc.) - ayaan.md.blr@gmail.com, 99025 87579
3. Discord handle - ayaan.md
4. Home page (if any)
5. Blog (if any)
6. GitHub profile link - https://github.com/ayaan-md-blr
7. Twitter, LinkedIn, other socials - https://www.linkedin.com/in/md-ayaan-blr/
8. Time zone - UTC+05:30
9. Link to a resume - https://drive.google.com/file/d/1kICrybHZfWLkmSFGOIfv9nFpnef14DPG/view?usp=sharing

### University Info

1. University name - PES University Bangalore
2. Program you are enrolled in (Degree & Major/Minor) - BTech (AI/ML)
3. Year - 2023
4. Expected graduation date - 2027

### Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):

1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

   No. My first experience is with apidash. I have raised a PR for issue #122(https://github.com/foss42/apidash/pull/713) and
   had a good learning. Fairly comfortable with the process now
   and looking forward to contribute and work towards merging the PR in the apidash repo.

2. What is your one project/achievement that you are most proud of? Why?

   I am proud of my self-learning journey in the AI area so far. I am equipped with considerable predictive and generative AI concepts and related tools/apis.
   I started with the perception that AI is new, exciting but extremely difficult. I overcame this challenge using multiple learning resources and balancing with
   my college academics and have been able to achieve much more than my peer group in terms of learning.
   Looking forward to learning and contributing to the open source space and add a new level to my learning journey.

3. What kind of problems or challenges motivate you the most to solve them?

   DSA related problems challenged me the most which also pushed me to solve them. I was able to solve complex problems in trees, graphs,
   recursion which I found very interesting.
   I am also part of the avions (college club related to aviation and aerospace) where we are building working models of airplanes. It is very challenging and at the
   same time motivating to make those models from scratch and fly them.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

   Yes I can contribute full time. I dont have any other engagements since it will be my summer break.

5. Do you mind regularly syncing up with the project mentors?

   Definitely not. This is the opportunity I am looking forward to where I can work with the bright minds and gain guidance and knowledge. I would be available for
   any form of communication as required by the assignment.

6. What interests you the most about API Dash?

   The simplicity of the gitrepo attracted me to this project. It is very easy to understand and very well written.

7. Can you mention some areas where the project can be improved?

   Developer documentation w.r.t to the components, system design, best practices, coding standards, testing standards will increase the productivity of contributors.
   Also I feel there can be improvement in the look and feel of the user interface in terms of making it appear attractive and also enhance usability.

### Project Proposal Information

1. Proposal Title - AI UI Designer for APIs (#617)
2. Abstract:
   Develop an AI Agent which transforms API responses into dynamic, user-friendly UI components, enabling developers to visualize and interact with data effortlessly.
   I plan to address this by building a new component ai_ui_agent which uses ollama models suitable for codegen (codellama or deepseek probably) to generate the flutter
   widgets which can be plugged into apidash ui. We can use third party component fl_chart for the charts generation.
3. Detailed Description
   A rough ui mockup can be as below.
   This popup will be rendered on click of the "data analysis" button on the response widget.
   The drop down can be populated from the responses from the ai model. (List the charts to analyze the data in the given json)
   On selection of each item in the drop down corresponding chart with customizations can be displayed.
   Export component (link/button) will export the flutter component as a zip file.
   ![](images/ayaan_mockup.png)

   ```
   To implement this we need to carry out the below tasks in order -

   Task1:

   Evaluate the Ollama supported LLMs with good code generation capability.

   	We need to attempt several prompts which give us the output as required.
   	We need the prompt to
   		- List the suitable widgets (data table/ chart/ card/ form) for the given json data.
   		- The prompts should be fine tuned to generate different types of widgets as chosen by user.
   		- The prompts should also have placeholders for customizations (Searching, sorting, custom labels in charts)
   		- The prompts should be fine tuned to provide the look and feel of the apidash ui.
   		- The prompts should give good performance as well as provide accuracy of output.
   	At the end of this task we should have working prompts as per the requirement.

   Task2: Build the ai_ui_agent component in the lib folder of the repo which encapsulates both the back end logic and ui widgets.
   	At the end of this task we expect a working component with the below structure :
   	ai_ui_agent
   		- features
   			ai_ui_agent_codegen.dart (This will contain the fine tuned prompts for code generation)
   			exporter.dart (This will contain the logic to export the generated flutter widget)
   		- providers
   			ai_ui_agent_providers.dart (Will hold the generated flutter code as state/ available for download)
   		- services
   			ai_ui_agent_service.dart (Will invoke the ollama service using ollama_dart package)
   		- widgets
   			ai_ui_widget.dart (container widget for the generated code)
   			(any other widgets required for customizations/styles)
   		- utils
   			validate_widget.dart (This should perform some basic validation/compilation to ensure the generated component can get rendered/exported successfully)
   	ai_ui_agent.dart

   Task3: Integrating this component with the response_pane widget
   	screens/home_page/editor_pane/details_card/response_pane.dart (Add a new button on click - render the ai_ui_widget in a pop up.)

   Task4: Writing unit and integration tests

   Task5: Perform functional testing with different apis and response formats.
   	This will be crucial to ensure it works with different apis with different json structures.
   	This task may involve fine tuning/fixing the prompts as well.

   Taks6: Updating the dev guide and user guide

   ```

4. Weekly Timeline:

| Week           | Focus                                                     | Key Deliverables & Achievements                                                              |
| -------------- | --------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| **Week 1**     | Community Bonding and dev env setup                       | Connect with mentors. Understand project expectations. Install and configure dev env.        |
| **Week 2-3**   | Task1: Evaluate Ollama codegen model and prompts creation | Working prompts and finalized Ollama ai model                                                |
| **Week 4-5**   | Task2: Build ai_ui_agent                                  | Features and Services                                                                        |
| **Week 6-7**   | Task2,3: Build ai_ui_agent                                | widgets, providers and utils                                                                 |
| **Week 8-9**   | Task4,5: unit, integration and functional testing         | Unit, integration tests, meet code coverage                                                  |
| **Week 9-10**  | Task6: Documentation                                      | Update Dev guide, User Guide, Readme, Changelog                                              |
| **Week 10-12** | Feedback and wrapup                                       | Implement any final feedback from mentors. Open to pick up other issue related to importers. |
