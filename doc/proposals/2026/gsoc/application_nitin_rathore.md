##GSoC 2026 Proposal: Enhancing AI Model Handling and User Experience in API Dash

Personal Information
Name: Nitin Rathore
University: IET DAVV, Indore
Year: 1st Year BTech IT

Introduction
API Dash is an open-source API client evolving to support AI-powered workflows. While contributing to the project, I identified several usability issues in AI model selection, error handling, and user interaction.

I have already contributed by fixing UI issues such as model selection fallback handling and layout responsiveness. These contributions helped me understand the current implementation and motivated me to further improve the AI workflow.

Problem Statement
The current AI workflow has the following challenges:

Unclear UI states in model selection such as empty or confusing labels

Lack of proper fallback handling for edge cases

Technical and non-intuitive error messages

Missing feedback during async operations

Minor UI inconsistencies across components

These issues reduce usability, especially for new users.

Proposed Solution

Model Selection Improvements

Proper fallback handling for null or empty states

Clear and consistent labeling

Improved selection dialog behavior

Error Handling

Replace technical errors with user-friendly messages

Provide actionable suggestions

Standardize error handling across components

User Feedback

Add loading indicators for AI requests

Show clear success and failure messages

Improve responsiveness during async operations

UI Consistency

Fix inconsistencies across AI components

Ensure uniform design and behavior

Technical Approach

Use structured state management such as Provider or Riverpod for consistent UI updates

Introduce a centralized system to convert technical errors into user-friendly messages

Implement loading states and notifications for better feedback

Refactor components like AIModelSelectorButton to improve readability and maintainability

Create reusable helper functions for validation and fallback handling

Implementation Plan

Phase 1: Analysis

Study current AI workflow and identify issues

Phase 2: Model Selection

Implement fallback handling

Improve UI clarity and handle edge cases

Phase 3: Error Handling

Refactor error messages

Standardize error handling

Phase 4: User Feedback

Add loaders and notifications

Improve UI responsiveness

Phase 5: Testing and Refinement

Test across devices

Fix edge cases

Phase 6: Documentation

Update documentation and add comments

Timeline

Weeks 1 to 2

Community bonding and planning

Weeks 3 to 4

Model selection improvements

Weeks 5 to 6

Error handling system

Weeks 7 to 8

User feedback enhancements

Weeks 9 to 10

UI consistency and testing

Weeks 11 to 12

Finalization and documentation

Deliverables

Improved model selection with proper fallback handling

User-friendly error handling system

Loading indicators and feedback mechanisms

Consistent UI across AI components

Reusable utilities for UI and error handling

Updated documentation

Impact

Better usability of AI features

Reduced confusion for users

Improved responsiveness and feedback

Cleaner and more maintainable codebase

Past Contributions

Fixed model selection fallback issue

Resolved UI overflow issues for better responsiveness

Improved edge case handling in AI components

https://github.com/foss42/apidash/pull/1048
https://github.com/foss42/apidash/pull/1412

Technical Skills
React, Next.js
Flutter, Dart
UI and UX design
REST API integration
Git and GitHub

About Me
I am a frontend-focused developer with a strong interest in building user-friendly applications and contributing to open source.

Through my contributions to API Dash, I have gained practical experience in improving UI behavior, handling edge cases, and working with real-world codebases. I focus on writing clean and maintainable code and solving practical problems through structured development.

Conclusion
With prior contributions and a clear understanding of the project, I am confident in delivering meaningful improvements to AI model handling and user experience in API Dash.

I look forward to collaborating with mentors and contributing effectively during GSoC.