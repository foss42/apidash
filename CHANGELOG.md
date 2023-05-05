# API Dash ⚡️ Changelog

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
For each request, you can click on **View Code** to directly view the corresponding Dart code which you can then *Copy* and directly run it on DartPad.

**Feature Preview (Video)👇**

https://user-images.githubusercontent.com/1382619/227082072-2c829996-2550-425d-ad73-e81f96d2d270.mp4

#### Other Features

- All user data is persisted locally on the disk. To save the current snapshot, just press the **Save** button in the collection pane. 
- You can also re-arrange (press and drag), duplicate and delete the API drafts.
