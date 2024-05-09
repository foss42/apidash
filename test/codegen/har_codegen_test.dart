import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/country/data?code=US",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "code",
      "value": "US"
    }
  ],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/country/data?code=IND",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "code",
      "value": "IND"
    }
  ],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "num",
      "value": "8700000"
    },
    {
      "name": "digits",
      "value": "3"
    },
    {
      "name": "system",
      "value": "SS"
    },
    {
      "name": "add_space",
      "value": "true"
    },
    {
      "name": "trailing_zeros",
      "value": "true"
    }
  ],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.github.com/repos/foss42/apidash",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ]
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.github.com/repos/foss42/apidash?raw=true",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "raw",
      "value": "true"
    }
  ],
  "headers": [
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ]
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.github.com/repos/foss42/apidash?raw=true",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "raw",
      "value": "true"
    }
  ],
  "headers": [
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ]
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/humanize/social?num=8700000&add_space=true",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "num",
      "value": "8700000"
    },
    {
      "name": "add_space",
      "value": "true"
    }
  ],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/humanize/social",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ]
}""";
      expect(
          codeGen.getCode(
            CodegenLanguage.har,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/humanize/social?num=8700000&digits=3",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "num",
      "value": "8700000"
    },
    {
      "name": "digits",
      "value": "3"
    }
  ],
  "headers": [
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ]
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.apidash.dev/humanize/social",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""{
  "method": "HEAD",
  "url": "https://api.apidash.dev",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""{
  "method": "HEAD",
  "url": "http://api.apidash.dev",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/case/lower",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "text/plain"
    }
  ],
  "postData": {
    "mimeType": "text/plain",
    "text": "{\n\"text\": \"I LOVE Flutter\"\n}"
  }
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/case/lower",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "application/json"
    }
  ],
  "postData": {
    "mimeType": "application/json",
    "text": "{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}"
  }
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/case/lower",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "application/json"
    },
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ],
  "postData": {
    "mimeType": "application/json",
    "text": "{\n\"text\": \"I LOVE Flutter\"\n}"
  }
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/io/form",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "multipart/form-data; boundary=d43e2510-a25e-1f08-b0a5-591aeb704467"
    }
  ],
  "postData": {
    "mimeType": "multipart/form-data; boundary=d43e2510-a25e-1f08-b0a5-591aeb704467",
    "params": [
      {
        "name": "text",
        "value": "API"
      },
      {
        "name": "sep",
        "value": "|"
      },
      {
        "name": "times",
        "value": "3"
      }
    ]
  }
}""";
      expect(
          codeGen.getCode(CodegenLanguage.har, requestModelPost4, "https",
              boundary: "d43e2510-a25e-1f08-b0a5-591aeb704467"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/io/form",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "multipart/form-data; boundary=ce268b20-a3e6-1f08-b0a5-591aeb704467"
    },
    {
      "name": "User-Agent",
      "value": "Test Agent"
    }
  ],
  "postData": {
    "mimeType": "multipart/form-data; boundary=ce268b20-a3e6-1f08-b0a5-591aeb704467",
    "params": [
      {
        "name": "text",
        "value": "API"
      },
      {
        "name": "sep",
        "value": "|"
      },
      {
        "name": "times",
        "value": "3"
      }
    ]
  }
}""";
      expect(
          codeGen.getCode(CodegenLanguage.har, requestModelPost5, "https",
              boundary: "ce268b20-a3e6-1f08-b0a5-591aeb704467"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/io/img",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "multipart/form-data; boundary=c90d21a0-a44d-1f08-b0a5-591aeb704467"
    }
  ],
  "postData": {
    "mimeType": "multipart/form-data; boundary=c90d21a0-a44d-1f08-b0a5-591aeb704467",
    "params": [
      {
        "name": "token",
        "value": "xyz"
      },
      {
        "name": "imfile",
        "fileName": "1.png"
      }
    ]
  }
}""";
      expect(
          codeGen.getCode(CodegenLanguage.har, requestModelPost6, "https",
              boundary: "c90d21a0-a44d-1f08-b0a5-591aeb704467"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/io/img",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "multipart/form-data; boundary=4ac86770-a4dc-1f08-b0a5-591aeb704467"
    }
  ],
  "postData": {
    "mimeType": "multipart/form-data; boundary=4ac86770-a4dc-1f08-b0a5-591aeb704467",
    "params": [
      {
        "name": "token",
        "value": "xyz"
      },
      {
        "name": "imfile",
        "fileName": "1.png"
      }
    ]
  }
}""";
      expect(
          codeGen.getCode(CodegenLanguage.har, requestModelPost7, "https",
              boundary: "4ac86770-a4dc-1f08-b0a5-591aeb704467"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/io/form?size=2&len=3",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "size",
      "value": "2"
    },
    {
      "name": "len",
      "value": "3"
    }
  ],
  "headers": [
    {
      "name": "Content-Type",
      "value": "multipart/form-data; boundary=78403a20-a54a-1f08-b0a5-591aeb704467"
    }
  ],
  "postData": {
    "mimeType": "multipart/form-data; boundary=78403a20-a54a-1f08-b0a5-591aeb704467",
    "params": [
      {
        "name": "text",
        "value": "API"
      },
      {
        "name": "sep",
        "value": "|"
      },
      {
        "name": "times",
        "value": "3"
      }
    ]
  }
}""";
      expect(
          codeGen.getCode(CodegenLanguage.har, requestModelPost8, "https",
              boundary: "78403a20-a54a-1f08-b0a5-591aeb704467"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.apidash.dev/io/img?size=2&len=3",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "size",
      "value": "2"
    },
    {
      "name": "len",
      "value": "3"
    }
  ],
  "headers": [
    {
      "name": "Content-Type",
      "value": "multipart/form-data; boundary=2d9cd390-a593-1f08-b0a5-591aeb704467"
    },
    {
      "name": "User-Agent",
      "value": "Test Agent"
    },
    {
      "name": "Keep-Alive",
      "value": "true"
    }
  ],
  "postData": {
    "mimeType": "multipart/form-data; boundary=2d9cd390-a593-1f08-b0a5-591aeb704467",
    "params": [
      {
        "name": "token",
        "value": "xyz"
      },
      {
        "name": "imfile",
        "fileName": "1.png"
      }
    ]
  }
}""";
      expect(
          codeGen.getCode(CodegenLanguage.har, requestModelPost9, "https",
              boundary: "2d9cd390-a593-1f08-b0a5-591aeb704467"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""{
  "method": "PUT",
  "url": "https://reqres.in/api/users/2",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "application/json"
    }
  ],
  "postData": {
    "mimeType": "application/json",
    "text": "{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}"
  }
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""{
  "method": "PATCH",
  "url": "https://reqres.in/api/users/2",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "application/json"
    }
  ],
  "postData": {
    "mimeType": "application/json",
    "text": "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
  }
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""{
  "method": "DELETE",
  "url": "https://reqres.in/api/users/2",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""{
  "method": "DELETE",
  "url": "https://reqres.in/api/users/2",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": [
    {
      "name": "Content-Type",
      "value": "application/json"
    }
  ],
  "postData": {
    "mimeType": "application/json",
    "text": "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
  }
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
