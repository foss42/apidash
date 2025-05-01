# API Dash ⚡️

[![Discord Server Invite](https://img.shields.io/badge/DISCORD-JOIN%20SERVER-5663F7?style=for-the-badge&logo=discord&logoColor=white)](https://discord.com/invite/bBeSdtJ6Ue)

### 🚨🚨 API Dash is participating in GSoC 2025! Check out the details below:

<img src="https://github.com/foss42/apidash/assets/615622/493ce57f-06c3-4789-b7ae-9fa63bca8183" alt="GSoC" width="500">

| | Link |
|--|--|
| Learn about GSoC | [Link](https://summerofcode.withgoogle.com) |
| API Dash GSoC Page | [Link](https://summerofcode.withgoogle.com/programs/2025/organizations/api-dash) |
| Project Ideas List | [Link](https://github.com/foss42/apidash/discussions/565) |
| Application Guide | [Link](https://github.com/foss42/apidash/discussions/564) |
| Discord Channel | [Link](https://discord.com/invite/bBeSdtJ6Ue) |


### Please support this initiative by giving this project a Star ⭐️

API Dash is a beautiful open-source cross-platform API Client that can help you easily create & customize your API requests, visually inspect responses ([full list of supported mime-types](https://github.com/foss42/apidash?tab=readme-ov-file#mime-types-supported-by-api-dash-response-previewer)) and generate API integration code ([full list](https://github.com/foss42/apidash?tab=readme-ov-file#code-generators)) on the go.

![API Dash](screenshots/apidash.png)

## Download

API Dash can be downloaded from the links below:

<table>
    <thead>
        <tr>
            <th>OS</th>
            <th>Distribution</th>
            <th>Installation Guide</th>
            <th>CPU/Architecture</th>
            <th>Download Link</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>iOS/iPad</td>
          <td>App Store</td>
            <td></td>
            <td></td>
            <td><a href="https://apps.apple.com/us/app/api-dash-api-client-testing/id6711353348">Link</a></td>
        </tr>
        <tr>
            <td>macOS</td>
          <td><code>.dmg</code></td>
            <td><a href="https://github.com/foss42/apidash/blob/main/INSTALLATION.md#macos">Link</a></td>
            <td>Apple Silicon & Intel</td>
            <td><a href="https://github.com/foss42/apidash/releases/latest/download/apidash-macos.dmg">Link</a></td>
        </tr>
        <tr>
            <td>Windows</td>
            <td><code>.exe</code></td>
            <td><a href="https://github.com/foss42/apidash/blob/main/INSTALLATION.md#windows">Link</a></td>
            <td>64-bit</td>
            <td><a href="https://github.com/foss42/apidash/releases/latest/download/apidash-windows-x86_64.exe">Link</a></td>
        </tr>
        <tr>
            <td rowspan=5>Linux</td>
            <td rowspan=2><code>.deb</code></td>          
            <td rowspan=2><a href="https://github.com/foss42/apidash/blob/main/INSTALLATION.md#debian-based-linux-distributions-debian-ubuntu-linux-mint-etc">Link</a></td>
            <td>amd64</td>
            <td><a href="https://github.com/foss42/apidash/releases/latest/download/apidash-linux-amd64.deb">Link</a></td>
        </tr>
         <tr>
            <td>arm64</td>
            <td><a href="https://github.com/foss42/apidash/releases/latest/download/apidash-linux-arm64.deb">Link</a></td>
        </tr>
        <tr>
            <td rowspan=2><code>.rpm</code></td>
            <td rowspan=2><a href="https://github.com/foss42/apidash/blob/main/INSTALLATION.md#red-hat-based-linux-distributions-fedora-rocky-almalinux-centos-rhel-etc">Link</a></td>
            <td>x86_64</td>
            <td><a href="https://github.com/foss42/apidash/releases/latest/download/apidash-linux-x86_64.rpm">Link</a></td>
        </tr>
         <tr>
            <td>aarch64</td>
            <td><a href="https://github.com/foss42/apidash/releases/latest/download/apidash-linux-aarch64.rpm">Link</a></td>
        </tr>
        <tr>
            <td><code>PKGBUILD</code> (Arch Linux)</td>
            <td><a href="https://aur.archlinux.org/packages/apidash-bin">Link</a></td>
            <td>x86_64</td>
            <td><a href="https://aur.archlinux.org/packages/apidash-bin">Link</a></td>
        </tr>
    </tbody>
</table>

## List of Features

| API Type | Supported |
| --- | --- |
| HTTP | ✅ |
| GraphQL | ✅ |
| SSE | https://github.com/foss42/apidash/issues/116 | 
| WebSocket | https://github.com/foss42/apidash/issues/15 |
| MQTT | https://github.com/foss42/apidash/issues/115 |
| gRPC | https://github.com/foss42/apidash/issues/14 |

| Import Collection From | Supported |
| --- | --- |
| Postman | ✅ |
| cURL | ✅ |
| Insomnia | ✅ | 
| OpenAPI | https://github.com/foss42/apidash/issues/121 |
| hurl | https://github.com/foss42/apidash/issues/123 |
| HAR | https://github.com/foss42/apidash/issues/122 |


**↗️ Create & Customize API Requests**

- Create different types of HTTP requests (`GET`, `HEAD`, `POST`, `PATCH`, `PUT` and `DELETE`).
- Easily manipulate and play around with request inputs like `headers`, `query parameters` and `body`.
- Full support to send text content with 🥳 Unicode/Emoji and preview any API response containing Unicode/Emoji.
- Create GraphQL requests with `headers` and `query`.

**💼 Organize Requests in Collections & Folders**

- Create collections and folders to organize your requests.
- Press and Drag to Re-arrange requests.
- Click and open popup menu to rename, duplicate and delete a request.

**🔎 Visually Preview and Download Data & Multimedia API Responses**

- Inspect the API Response (HTTP status code, error message, headers, body, time taken).
- View formatted code previews for responses of various content types like `JSON`, `XML`, `YAML`, `HTML`, `SQL`, etc.
- API Dash helps explore, test & preview Multimedia API responses which is **not supported by any other API client**. You can directly test APIs that return images, PDF, audio & more. Check out the [full list of supported MIME types/formats here](https://github.com/foss42/apidash?tab=readme-ov-file#mime-types-supported-by-api-dash-response-previewer).
- Save 💾 response body of any mimetype (`image`, `text`, etc.) directly in the `Downloads` folder of your system by clicking on the `Download` button.

**👩🏻‍💻 Code Generation**

- We started out as the **only** open source API client which supported advanced Dart code generation to easily integrate APIs in Dart/Flutter projects or to directly run it on DartPad. With time we have added more code-gens and currently API Dash supports generation of well-tested integration codes for **JavaScript**, **Python**, **Kotlin** & various other languages. You can check out the [full list of supported languages/libraries](https://github.com/foss42/apidash?tab=readme-ov-file#code-generators).

**🌙 Full Dark Mode Support**

- Easily switch between light mode and dark mode.

**💾 Data**

- Data is persisted locally on the disk. To save the current snapshot, just press the **Save** button in the collection pane.
- Click and open the collection/folder popup menu to export it as HAR. This can be version controlled & can be directly imported in other API Clients like Postman, Paw, etc.
- Export your entire data into a HAR (HTTP Archive) file. To access this option goto `Settings > Export Data`.

**⚙️ Settings & Other Options**

- Customize various options using a dedicated Settings screen.
- Window Configuration (Size & Position) is persisted and restored on app start. (Only macOS & Windows)

## Code Generators

API Dash currently supports API integration code generation for the following languages/libraries.

| Language               | Library       | Comment/Issues |
| ---------------------- | ------------- | ------- |
| cURL                   |               |         |
| HAR                    |               |         |
| C                      | `libcurl`     |         |
| C#                     | `HttpClient`  |         |
| C#                     | `RestSharp`   |         |
| Dart                   | `http`        |         |
| Dart                   | `dio`         |         |
| Go                     | `net/http`    |         |
| JavaScript             | `axios`       |         |
| JavaScript             | `fetch`       |         |
| JavaScript (`node.js`) | `axios`       |         |
| JavaScript (`node.js`) | `fetch`       |         |
| Java                   | `asynchttpclient` |     |
| Java                   | `HttpClient`  |         |
| Java                   | `okhttp3`     |         |
| Java                   | `Unirest`     |         |
| Julia                  | `HTTP`        |         |
| Kotlin                 | `okhttp3`     |         |
| PHP                    | `curl`        |         |
| PHP                    | `guzzle`      |         |
| PHP                    | `HTTPlug`     |         |
| Python                 | `requests`    |         |
| Python                 | `http.client` |         |
| Ruby                   | `faraday`     |         |
| Ruby                   | `net/http`    |         |
| Rust                   | `hyper`       |         |
| Rust                   | `reqwest`     |         |
| Rust                   | `ureq`        |         |
| Rust                   | `Actix Client` |        |
| Swift                  | `Alamofire`   |         |
| Swift                  | `URLSession`  |         |

We welcome contributions to support other programming languages/libraries/frameworks. Please check out more details [here](https://github.com/foss42/apidash/discussions/80).

## MIME Types supported by API Dash Response Previewer

API Dash is a next-gen API client that supports exploring, testing & previewing various data & multimedia API responses which is limited/not supported by other API clients. You can directly test APIs that return images, PDF, audio & more.

Here is the complete list of MIME types that can be directly previewed in API Dash:

| File Type | Mimetype                   | Extension         | Comment  |
| --------- | -------------------------- | ----------------- | -------- |
| PDF       | `application/pdf`          | `.pdf`            |          |
| Video     | `video/mp4`                | `.mp4`            |          |
| Video     | `video/webm`               | `.webm`           |          |
| Video     | `video/x-ms-wmv`           | `.wmv`            |          |
| Video     | `video/x-ms-asf`           | `.wmv`            |          |
| Video     | `video/avi`                | `.avi`            |          |
| Video     | `video/msvideo`            | `.avi`            |          |
| Video     | `video/x-msvideo`          | `.avi`            |          |
| Video     | `video/quicktime`          | `.mov`            |          |
| Video     | `video/x-quicktime`        | `.mov`            |          |
| Video     | `video/x-matroska`         | `.mkv`            |          |
| Image     | `image/apng`               | `.apng`           | Animated |
| Image     | `image/avif`               | `.avif`           |          |
| Image     | `image/bmp`                | `.bmp`            |          |
| Image     | `image/gif`                | `.gif`            | Animated |
| Image     | `image/jpeg`               | `.jpeg` or `.jpg` |          |
| Image     | `image/jp2`                | `.jp2`            |          |
| Image     | `image/jpx`                | `.jpf` or `.jpx`  |          |
| Image     | `image/pict`               | `.pct`            |          |
| Image     | `image/portable-anymap`    | `.pnm`            |          |
| Image     | `image/png`                | `.png`            |          |
| Image     | `image/sgi`                | `.sgi`            |          |
| Image     | `image/svg+xml`            | `.svg`            |          |
| Image     | `image/tiff`               | `.tiff`           |          |
| Image     | `image/targa`              | `.tga`            |          |
| Image     | `image/vnd.wap.wbmp`       | `.wbmp`           |          |
| Image     | `image/webp`               | `.webp`           |          |
| Image     | `image/xwindowdump`        | `.xwd`            |          |
| Image     | `image/x-icon`             | `.ico`            |          |
| Image     | `image/x-portable-anymap`  | `.pnm`            |          |
| Image     | `image/x-portable-bitmap`  | `.pbm`            |          |
| Image     | `image/x-portable-graymap` | `.pgm`            |          |
| Image     | `image/x-portable-pixmap`  | `.ppm`            |          |
| Image     | `image/x-tga`              | `.tga`            |          |
| Image     | `image/x-xwindowdump`      | `.xwd`            |          |
| Audio     | `audio/flac`               | `.flac`           |          |
| Audio     | `audio/mpeg`               | `.mp3`            |          |
| Audio     | `audio/mp4`                | `.m4a` or `.mp4a` |          |
| Audio     | `audio/x-m4a`              | `.m4a`            |          |
| Audio     | `audio/wav`                | `.wav`            |          |
| Audio     | `audio/wave`               | `.wav`            |          |
| CSV       | `text/csv`                 | `.csv`            | Can be improved |

We welcome PRs to add support for previewing other multimedia MIME types. Please go ahead and raise an issue so that we can discuss the approach.
We are adding support for other MIME types with each release. But, if you are looking for any particular mimetype support, please go ahead and open an issue. We will prioritize it's addition.

Here is the complete list of MIME types that are syntax highlighted in API Dash:

| Mimetype           | Extension | Comment                                                                                                            |
| ------------------ | --------- | ------------------------------------------------------------------------------------------------------------------ |
| `application/json` | `.json`   | Other MIME types like `application/geo+json`, `application/vcard+json` that are based on `json` are also supported. |
| `application/xml`  | `.xml`    | Other MIME types like `application/xhtml+xml`, `application/vcard+xml` that are based on `xml` are also supported.  |
| `text/xml`         | `.xml`    |  |
| `application/yaml` | `.yaml`   | Others - `application/x-yaml` or `application/x-yml` |
| `text/yaml`        | `.yaml`   | Others - `text/yml` |
| `application/sql`  | `.sql`    |  |
| `text/css`         | `.css`    |  |
| `text/html`        | `.html`   | Only syntax highlighting, no web preview. |
| `text/javascript`  | `.js`     |  |
| `text/markdown`    | `.md`     |  |

## What's new in v0.5.0?

Visit [CHANGELOG.md](CHANGELOG.md)

## Provide Feedback, Report Bugs & Request New Features

Just click on the [Issue tab](https://github.com/foss42/apidash/issues) to raise a new issue in this repo.

## Roadmap

Please find the Roadmap for API Dash [here](https://github.com/foss42/apidash/blob/main/ROADMAP.md).

## Documentation (User Guide & Developer Guide)

All docs are currently available in the [doc](https://github.com/foss42/apidash/blob/main/doc/) folder.

## Resources for New Contributors

- Developer Guide - [Read](https://github.com/foss42/apidash/blob/main/doc/dev_guide/README.md)
- Code Walkthrough - [Video](https://www.youtube.com/live/rIlwCTKNz-A?si=iMxTxzkpY_ySo4Ow&t=339)

## Contribute to API Dash

You can contribute to API Dash in any or all of the following ways:

- [Ask a question](https://github.com/foss42/apidash/discussions)
- [Submit a bug report](https://github.com/foss42/apidash/issues/new/choose)
- [Request a new feature](https://github.com/foss42/apidash/issues/new/choose)
- [Choose from our existing list of ideas](https://github.com/foss42/apidash/discussions/565)
- [Suggest ways to improve the developer experience of an existing feature](https://github.com/foss42/apidash/issues/new/choose)
- Add documentation
- To add a new feature, resolve an existing issue or add a new test to the project, check out our [Contribution Guidelines](CONTRIBUTING.md).

## Need Any Help?

In case you need any help with API Dash or are encountering any issue while running the tool, please feel free to drop by our [Discord server](https://discord.com/invite/bBeSdtJ6Ue) and we can have a chat in the **#foss-apidash** channel.
