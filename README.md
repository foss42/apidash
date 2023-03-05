# API Dash ⚡️

API Dash is a beautiful open-source cross-platform HTTP Client that can help you explore APIs.

Using API Dash, you can draft API requests via an easy to use GUI. It allows you to:
- Create different types of HTTP requests (GET, POST, PUT, etc.)
- Easily manipulate and play around with request inputs like headers, query parameters and body.
- Parse the response to inspect the outputs (HTTP status code, error messages, header, body, time taken) to better understand, debug and test the APIs. 

![apidash (1)](https://user-images.githubusercontent.com/1382619/222961170-ae45c4b8-2f23-4308-9d90-3a8af237a673.png)


## Motivation

Our team (Ankit & Ashita) started the [foss42](https://foss42.com) initiative of building open source APIs a few months back and after working with various API clients we always felt that many of these clients lacked cross-platform support and good code generation ability especially for mobile first developers. As Flutter is a cross platform framework and could help us achieve this from a single code-base, we decided to start working on this open source initiative in FOSS Hack 3.0 using Flutter.

## Project Timeline

This is a new project that was started on 4th March, 2023.

## Roadmap

The following is the initial roadmap that we laid out before we started hacking this project. (What we have acheived so far has a tick ✅)

✅ App UI  
✅ Allowing users to create, duplicate, delete, rearrange API requests  
✅ Flutter App State Management using riverpod  
✅ Users can select the request method (GET, POST, PATCH, etc.)  
✅ Users can input query parameters, headers and body  
✅ Fetching results  
✅ Displaying results is a nice form  
✅ Users can take a copy of the response  
❌ Generating the Dart code corresponding to the requests  
❌ Saving the collection of requests created by the user (Persistence)  

## Current Limitations

- The request body currently supports only text and json input. File, Form-field and other inputs will be supported soon.
- The response body that can be currently visualized should be a text or json. We have plans to support more mime-types in near future. For example, is the response is a video, the user will be able to directly play that video in near future.
- Due to time constraints we currently do not have collection persistence or export as it will require some more work and we will continue working on it.
