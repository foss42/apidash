# API Dash ⚡️ Changelog

## v0.4.0 [WIP]

In this release, we have added the following features:

1. Save on Close so that you are prompted to save when you close the app. You can change this setting anytime in the Settings.
2. JSON previewer Bug fixes.
3. Clean new look on Windows.
4. Arch Linux Support
5. Checkbox for URL Params & Headers
6. Support for SVG response
7. Multi-part request & form data support
8. Dio Code generator
9. Dart http codegen has been rewritten using dart code builder
10. Ability to override request contenttype
11. More header suggestions
    

## v0.3.0 [29-11-2023]

In this major release, we have migrated the project to Dart 3 & added tons of amazing new features mentioned below:

1. Create collections and folders to easily organize your APIs.

![Collections and Folders](https://github.com/foss42/apidash/assets/615622/4f4de13e-60fd-4b0c-88d2-e3818d787e93)

2. Well tested code generators for `cURL`, `HAR`, Python (`requests`, `http.client`), JavaScript (`axios`, `fetch`), node.js (`axios`, `fetch`) & Kotlin (`okhttp3`).

![New Code Generators](https://github.com/foss42/apidash/assets/615622/2ff1b071-cbeb-4603-a11c-bd6b5f52f364)

3. Interactive JSON Response viewer with a Find Box to easily explore the results.

![JSON Viewer](https://github.com/foss42/apidash/assets/615622/5a7dd8c1-32e8-4277-af92-6a8947bc9cc5)

4. Auto-suggestions for the most popularly used headers.

![Auto-suggestions](https://github.com/foss42/apidash/assets/615622/c8a763c6-91ea-4262-86f9-52c6c99a435a)

5. Export collections & folders into a `HAR` (HTTP Archive) file that can be version controlled & can be directly imported in other API Clients like Postman, Paw, etc. You can also export your entire data via `Settings > Export Data`.

![Export Collection](https://github.com/foss42/apidash/assets/615622/d4e4ea43-cf5d-4e4a-9069-1574c512a3ad)
![Export Data](https://github.com/foss42/apidash/assets/615622/cda22e7d-a588-47e4-a5f7-5dccef889bd1)

6. Tab indicators for Request URL Parameters, Headers and Body tabs to quickly identify if they are populated.

![Tab Indicators](https://github.com/foss42/apidash/assets/615622/f1eacf28-ed79-4e2c-8438-c307f9f6f38a)

7. Support for PDF response

![PDF](https://github.com/foss42/apidash/assets/615622/39b45290-47ab-4b3d-a19d-1406bbb8cc68)

8. Support for Audio (wav , mp3) response

![Audio](https://github.com/foss42/apidash/assets/615622/e2f61c92-3c40-4dd6-a654-f3148badfa8e)

9. Support for APNG response

![APNG](https://github.com/foss42/apidash/assets/615622/bb8d58df-afb7-4495-94a9-83071443fcf7)

10. Updated Help & Support page.

![help & Support](https://github.com/foss42/apidash/assets/615622/8c2d82b1-1395-472a-b9f4-469fd9ab6bbb)

11. Scrollbar added to collection pane which can be switched between being permanently visible or being visible only while scrolling.

![scroll](https://github.com/foss42/apidash/assets/615622/4aab396e-ba0d-4b21-b04f-f8127e6d21eb)

along with other bug fixes & performance updates.

A big thank you to these wonderful developers for their contributions in this release: [@aqsasayyed](https://github.com/aqsasayyed), [@mmjsmohit](https://github.com/mmjsmohit), [@Dushant-Bansal](https://github.com/Dushant-Bansal), [@Mixel2004](https://github.com/Mixel2004), [@morpheus-30](https://github.com/morpheus-30) & [@madhupashish](https://github.com/madhupashish)

## v0.2.0 [05-05-2023]

The following features were added in this release:

1. A brand new UI with Settings.

<img width="1012" alt="light-ui" src="https://user-images.githubusercontent.com/615622/236202665-37f9193f-9e7d-4a0e-a9e1-cba198b8a22a.png">

2. Dark Mode Support

https://user-images.githubusercontent.com/615622/236202915-fbeeca4e-5108-41da-858a-1b7ba2b4f579.mov

3. You can now rename any request. Just double-click on it and enter the name.

https://user-images.githubusercontent.com/615622/236203140-54088e4f-84ec-4280-b4cd-334eb7b549e1.mov

4. Emoji support across the app. You can now easily send text content with emojis and preview any API response containing emojis.

<img width="1012" alt="light-emoji" src="https://user-images.githubusercontent.com/615622/236203297-31bc0381-91be-4c7c-8ace-c17aeec061ad.png">

5. You can now save response body of any mimetype (image, text, etc.) directly in the Downloads folder by clicking on the Download button.

<img width="516" alt="light-download" src="https://user-images.githubusercontent.com/615622/236203401-754da8d1-291f-492d-b870-eb1fb36372f7.png">

6. Window size and position is persisted and the configuration is restored on app start. (Only macOS & Windows)
7. Notification on save, download and any other user action (UX improvement).
8. Linux builds are now available for API Dash (.deb & .rpm)

.. and various bug fixes & performance improvements.

## v0.1.0 [27-03-2023]

Initial release

![OG_v2](https://user-images.githubusercontent.com/1382619/226843161-a70bd080-8565-4513-a8f2-21927ecd50bf.png)

### Features included in v0.1.0

#### 1. Create & Customize API Requests

Draft API requests via an easy to use GUI which allows you to:

- Create different types of HTTP requests (GET, HEAD, POST, PATCH, PUT and DELETE)
- Easily manipulate and play around with request inputs like headers, query parameters and body.

**Feature Preview (Video)👇**

https://user-images.githubusercontent.com/1382619/227081895-22af076f-469c-4f70-86e6-3dda8beccd31.mp4

#### 2. Visually inspect API Responses

- Inspect the API Response (HTTP status code, error message, headers, body, time taken)
- View formatted code previews for responses of various content types like JSON, XML, YAML, HTML, SQL, etc.
- For APIs which return results as images, API Dash helps you save a lot of time by directly previewing these results and supports a wide variety of image file formats such as jpeg, png, gif, etc.

**Feature Preview (Video)👇**

https://user-images.githubusercontent.com/1382619/227082005-7b374f5a-c406-4963-8f97-71fda4a58f69.mp4

#### 3. Generate Dart Code Automatically

API Dash is the **only** open source API client that supports Dart code generation so that you can easily integrate APIs in your Dart/Flutter project.
For each request, you can click on **View Code** to directly view the corresponding Dart code which you can then _Copy_ and directly run it on DartPad.

**Feature Preview (Video)👇**

https://user-images.githubusercontent.com/1382619/227082072-2c829996-2550-425d-ad73-e81f96d2d270.mp4

#### Other Features

- All user data is persisted locally on the disk. To save the current snapshot, just press the **Save** button in the collection pane.
- You can also re-arrange (press and drag), duplicate and delete the API drafts.
