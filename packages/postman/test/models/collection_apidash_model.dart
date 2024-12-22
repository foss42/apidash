import 'package:postman/models/models.dart';

var collectionApiDashModel = PostmanCollection(
  info: Info(
    postmanId: "a31e8a59-aa12-48c5-96a3-133822d7247e",
    name: "API Dash",
    schema:
        "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    exporterId: "26763819",
  ),
  item: [
    Item(
      name: "GET Requests",
      request: null,
      response: null,
      item: [
        Item(
          name: "Simple GET",
          request: Request(
              method: "GET",
              header: [],
              url: Url(
                raw: "https://api.apidash.dev",
                protocol: "https",
                host: ["api", "apidash", "dev"],
                path: null,
                query: null,
              )),
          response: [],
          item: null,
        ),
        Item(
          name: "Country Data",
          request: Request(
              method: "GET",
              header: [],
              url: Url(
                  raw: "https://api.apidash.dev/country/data?code=US",
                  protocol: "https",
                  host: ["api", "apidash", "dev"],
                  path: ["country", "data"],
                  query: [Query(key: "code", value: "US")])),
          response: [],
          item: null,
        ),
        Item(
          name: "Humanize Rank",
          request: Request(
              method: "GET",
              header: [],
              url: Url(
                  raw:
                      "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
                  protocol: "https",
                  host: [
                    "api",
                    "apidash",
                    "dev"
                  ],
                  path: [
                    "humanize",
                    "social"
                  ],
                  query: [
                    Query(key: "num", value: "8700000"),
                    Query(key: "digits", value: "3"),
                    Query(key: "system", value: "SS"),
                    Query(key: "add_space", value: "true"),
                    Query(key: "trailing_zeros", value: "true"),
                  ])),
          response: [],
          item: null,
        ),
      ],
    ),
    Item(
      name: "POST Requests",
      request: null,
      response: null,
      item: [
        Item(
          name: "Case Lower",
          request: Request(
              method: "POST",
              header: [],
              body: Body(
                mode: "raw",
                options: Options(raw: Raw(language: "json")),
                raw: "{\n\"text\": \"I LOVE Flutter\"\n}",
                formdata: null,
              ),
              url: Url(
                raw: "https://api.apidash.dev/case/lower",
                protocol: "https",
                host: ["api", "apidash", "dev"],
                path: ["case", "lower"],
                query: null,
              )),
          response: [],
          item: null,
        ),
        Item(
          name: "Form Example",
          request: Request(
              method: "POST",
              header: [
                Header(
                  key: "User-Agent",
                  value: "Test Agent",
                  type: "text",
                  disabled: null,
                )
              ],
              body: Body(
                mode: "formdata",
                options: null,
                raw: null,
                formdata: [
                  Formdatum(key: "text", value: "API", type: "text"),
                  Formdatum(key: "sep", value: "|", type: "text"),
                  Formdatum(key: "times", value: "3", type: "text"),
                ],
              ),
              url: Url(
                raw: "https://api.apidash.dev/io/form",
                protocol: "https",
                host: ["api", "apidash", "dev"],
                path: ["io", "form"],
                query: null,
              )),
          response: [],
          item: null,
        ),
        Item(
          name: "Form with File",
          request: Request(
              method: "POST",
              header: [],
              body: Body(
                mode: "formdata",
                options: null,
                raw: null,
                formdata: [
                  Formdatum(key: "token", value: "xyz", type: "text"),
                  Formdatum(
                      key: "imfile",
                      value: null,
                      src: "/Users/ashitaprasad/Downloads/hire AI.jpeg",
                      type: "file"),
                ],
              ),
              url: Url(
                raw: "https://api.apidash.dev/io/img",
                protocol: "https",
                host: ["api", "apidash", "dev"],
                path: ["io", "img"],
                query: null,
              )),
          response: [],
          item: null,
        ),
      ],
    ),
  ],
);
