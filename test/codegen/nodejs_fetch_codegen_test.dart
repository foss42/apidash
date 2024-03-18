import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/country/data?code=US';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/country/data?code=IND';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.github.com/repos/foss42/apidash';

const options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.github.com/repos/foss42/apidash?raw=true';

const options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.github.com/repos/foss42/apidash?raw=true';

const options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/humanize/social?num=8700000&add_space=true';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/humanize/social';

const options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.nodejsFetch,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/humanize/social?num=8700000&digits=3';

const options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/humanize/social';

const options = {
  method: 'GET'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev';

const options = {
  method: 'HEAD'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'http://api.apidash.dev';

const options = {
  method: 'HEAD'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/case/lower';

const options = {
  method: 'POST',
  headers: {
    "Content-Type": "text/plain"
  },
  body: "{\n\"text\": \"I LOVE Flutter\"\n}"
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/case/lower';

const options = {
  method: 'POST',
  headers: {
    "Content-Type": "application/json"
  },
  body: "{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}"
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://api.apidash.dev/case/lower';

const options = {
  method: 'POST',
  headers: {
    "Content-Type": "application/json",
    "User-Agent": "Test Agent"
  },
  body: "{\n\"text\": \"I LOVE Flutter\"\n}"
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""import fetch from 'node-fetch'
import { FormData } from 'node-fetch'

const payload = new FormData();
payload.append("text", "API")
payload.append("sep", "|")
payload.append("times", "3")

const url = 'https://api.apidash.dev/io/form';

const options = {
  method: 'POST',
  body: payload
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost4, "https",
              boundary: "test"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import fetch from 'node-fetch'
import { FormData } from 'node-fetch'

const payload = new FormData();
payload.append("text", "API")
payload.append("sep", "|")
payload.append("times", "3")

const url = 'https://api.apidash.dev/io/form';

const options = {
  method: 'POST',
  headers: {
    "User-Agent": "Test Agent"
  },
  body: payload
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost5, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""import fetch from 'node-fetch'
import { fileFromSync, FormData } from 'node-fetch'

const payload = new FormData();
payload.append("token", "xyz")
payload.append("imfile", fileFromSync("/Documents/up/1.png"))

const url = 'https://api.apidash.dev/io/img';

const options = {
  method: 'POST',
  body: payload
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost6, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""import fetch from 'node-fetch'
import { fileFromSync, FormData } from 'node-fetch'

const payload = new FormData();
payload.append("token", "xyz")
payload.append("imfile", fileFromSync("/Documents/up/1.png"))

const url = 'https://api.apidash.dev/io/img';

const options = {
  method: 'POST',
  body: payload
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost7, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""import fetch from 'node-fetch'
import { FormData } from 'node-fetch'

const payload = new FormData();
payload.append("text", "API")
payload.append("sep", "|")
payload.append("times", "3")

const url = 'https://api.apidash.dev/io/form?size=2&len=3';

const options = {
  method: 'POST',
  body: payload
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost8, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""import fetch from 'node-fetch'
import { fileFromSync, FormData } from 'node-fetch'

const payload = new FormData();
payload.append("token", "xyz")
payload.append("imfile", fileFromSync("/Documents/up/1.png"))

const url = 'https://api.apidash.dev/io/img?size=2&len=3';

const options = {
  method: 'POST',
  headers: {
    "User-Agent": "Test Agent",
    "Keep-Alive": "true"
  },
  body: payload
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPost9, "https",
              boundary: "test"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://reqres.in/api/users/2';

const options = {
  method: 'PUT',
  headers: {
    "Content-Type": "application/json"
  },
  body: "{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}"
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://reqres.in/api/users/2';

const options = {
  method: 'PATCH',
  headers: {
    "Content-Type": "application/json"
  },
  body: "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://reqres.in/api/users/2';

const options = {
  method: 'DELETE'
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import fetch from 'node-fetch'

const url = 'https://reqres.in/api/users/2';

const options = {
  method: 'DELETE',
  headers: {
    "Content-Type": "application/json"
  },
  body: "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:${err}`);
  });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
