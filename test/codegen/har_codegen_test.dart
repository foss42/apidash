import 'package:apidash/codegen/others/har.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final harCodeGen = HARCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/country/data?code=US",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "code",
      "value": "US"
    }
  ],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/country/data?code=IND",
  "httpVersion": "HTTP/1.1",
  "queryString": [
    {
      "name": "code",
      "value": "IND"
    }
  ],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
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
      expect(harCodeGen.getCode(requestModelGet4, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelGet5, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelGet7, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/humanize/social?num=8700000&add_space=true",
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
      expect(harCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/humanize/social",
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
          harCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/humanize/social?num=8700000&digits=3",
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
      expect(harCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com/humanize/social",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""{
  "method": "HEAD",
  "url": "https://api.foss42.com",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""{
  "method": "HEAD",
  "url": "http://api.foss42.com",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(harCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.foss42.com/case/lower",
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
      expect(harCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.foss42.com/case/lower",
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
    "text": "{\n\"text\": \"I LOVE Flutter\"\n}"
  }
}""";
      expect(harCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""{
  "method": "POST",
  "url": "https://api.foss42.com/case/lower",
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
      expect(harCodeGen.getCode(requestModelPost3, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelPut1, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
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
      expect(harCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
