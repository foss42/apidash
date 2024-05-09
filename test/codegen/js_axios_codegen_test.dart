import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev',
  method: 'get'
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/country/data',
  method: 'get',
  params: {
    "code": "US"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/country/data',
  method: 'get',
  params: {
    "code": "IND"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": "8700000",
    "digits": "3",
    "system": "SS",
    "add_space": "true",
    "trailing_zeros": "true"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""const config = {
  url: 'https://api.github.com/repos/foss42/apidash',
  method: 'get',
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""const config = {
  url: 'https://api.github.com/repos/foss42/apidash',
  method: 'get',
  params: {
    "raw": "true"
  },
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev',
  method: 'get'
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""const config = {
  url: 'https://api.github.com/repos/foss42/apidash',
  method: 'get',
  params: {
    "raw": "true"
  },
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": "8700000",
    "add_space": "true"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": "8700000",
    "digits": "3"
  },
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get'
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev',
  method: 'head'
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""const config = {
  url: 'http://api.apidash.dev',
  method: 'head'
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/case/lower',
  method: 'post',
  headers: {
    "Content-Type": "text/plain"
  },
  data: "{\n\"text\": \"I LOVE Flutter\"\n}"
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/case/lower',
  method: 'post',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}"
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/case/lower',
  method: 'post',
  headers: {
    "Content-Type": "application/json",
    "User-Agent": "Test Agent"
  },
  data: "{\n\"text\": \"I LOVE Flutter\"\n}"
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: {
    "text": "API",
    "sep": "|",
    "times": "3"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelPost4,
            "https",
          ),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data",
    "User-Agent": "Test Agent"
  },
  data: {
    "text": "API",
    "sep": "|",
    "times": "3"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelPost5,
            "https",
          ),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode =
          r"""// refer https://github.com/foss42/apidash/issues/293#issuecomment-1997568083 for details regarding integration

const config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: {
    "token": "xyz",
    "imfile": fileInput1.files[0]
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelPost6,
            "https",
          ),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode =
          r"""// refer https://github.com/foss42/apidash/issues/293#issuecomment-1997568083 for details regarding integration

const config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: {
    "token": "xyz",
    "imfile": fileInput1.files[0]
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelPost7,
            "https",
          ),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""const config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  params: {
    "size": "2",
    "len": "3"
  },
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: {
    "text": "API",
    "sep": "|",
    "times": "3"
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelPost8,
            "https",
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode =
          r"""// refer https://github.com/foss42/apidash/issues/293#issuecomment-1997568083 for details regarding integration

const config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  params: {
    "size": "2",
    "len": "3"
  },
  headers: {
    "Content-Type": "multipart/form-data",
    "User-Agent": "Test Agent",
    "Keep-Alive": "true"
  },
  data: {
    "token": "xyz",
    "imfile": fileInput1.files[0]
  }
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsAxios,
            requestModelPost9,
            "https",
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'put',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}"
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'patch',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'delete'
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.jsAxios, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'delete',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.jsAxios, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
