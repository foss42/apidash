import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.apidash.dev/country/data',
  method: 'get',
  params: {
    "code": [
      "US"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
            CodegenLanguage.nodejsAxios,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.apidash.dev/country/data',
  method: 'get',
  params: {
    "code": [
      "IND",
      "US"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
            CodegenLanguage.nodejsAxios,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": [
      "8700000"
    ],
    "digits": [
      "3"
    ],
    "system": [
      "SS"
    ],
    "add_space": [
      "true"
    ],
    "trailing_zeros": [
      "true"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
            CodegenLanguage.nodejsAxios,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.github.com/repos/foss42/apidash',
  method: 'get',
  params: {
    "raw": [
      "true"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.github.com/repos/foss42/apidash',
  method: 'get',
  params: {
    "raw": [
      "true"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": [
      "8700000"
    ],
    "add_space": [
      "true"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
            CodegenLanguage.nodejsAxios,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
            CodegenLanguage.nodejsAxios,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": [
      "8700000"
    ],
    "digits": [
      "3"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
            CodegenLanguage.nodejsAxios,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
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
            CodegenLanguage.nodejsAxios,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
import fs from 'fs'
const config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: {
    "token": "xyz",
    "imfile": fs.createReadStream("/Documents/up/1.png")
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
            CodegenLanguage.nodejsAxios,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
import fs from 'fs'
const config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: {
    "token": "xyz",
    "imfile": fs.createReadStream("/Documents/up/1.png")
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
            CodegenLanguage.nodejsAxios,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  params: {
    "size": [
      "2"
    ],
    "len": [
      "3"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
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
            CodegenLanguage.nodejsAxios,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
import fs from 'fs'
const config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  params: {
    "size": [
      "2"
    ],
    "len": [
      "3"
    ]
  },
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'repeat' });
  },
  headers: {
    "Content-Type": "multipart/form-data",
    "User-Agent": "Test Agent",
    "Keep-Alive": "true"
  },
  data: {
    "token": "xyz",
    "imfile": fs.createReadStream("/Documents/up/1.png")
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
            CodegenLanguage.nodejsAxios,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'put',
  headers: {
    "Content-Type": "application/json",
    "x-api-key": "reqres-free-v1"
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
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'patch',
  headers: {
    "Content-Type": "application/json",
    "x-api-key": "reqres-free-v1"
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
            CodegenLanguage.nodejsAxios,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'delete',
  headers: {
    "x-api-key": "reqres-free-v1"
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
            CodegenLanguage.nodejsAxios,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import axios from 'axios';
import qs from 'qs';
const config = {
  url: 'https://reqres.in/api/users/2',
  method: 'delete',
  headers: {
    "Content-Type": "application/json",
    "x-api-key": "reqres-free-v1"
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
            CodegenLanguage.nodejsAxios,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
