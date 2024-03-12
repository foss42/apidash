import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""let url = 'https://api.apidash.dev';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/country/data?code=US';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/country/data?code=IND';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode =
          r"""let url = 'https://api.github.com/repos/foss42/apidash';

let options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode =
          r"""let url = 'https://api.github.com/repos/foss42/apidash?raw=true';

let options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""let url = 'https://api.apidash.dev';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode =
          r"""let url = 'https://api.github.com/repos/foss42/apidash?raw=true';

let options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/humanize/social?num=8700000&add_space=true';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/humanize/social';

let options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.jsFetch,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/humanize/social?num=8700000&digits=3';

let options = {
  method: 'GET',
  headers: {
    "User-Agent": "Test Agent"
  }
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode =
          r"""let url = 'https://api.apidash.dev/humanize/social';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""let url = 'https://api.apidash.dev';

let options = {
  method: 'HEAD'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""let url = 'http://api.apidash.dev';

let options = {
  method: 'HEAD'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""let url = 'https://api.apidash.dev/case/lower';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "text/plain"
  },
  body: 
"{\n\"text\": \"I LOVE Flutter\"\n}"
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""let url = 'https://api.apidash.dev/case/lower';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "application/json"
  },
  body: 
"{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}"
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""let url = 'https://api.apidash.dev/case/lower';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "application/json",
    "User-Agent": "Test Agent"
  },
  body: 
"{\n\"text\": \"I LOVE Flutter\"\n}"
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fileInput.files[0],value);
      }
    }
  return formdata;
}

const payload = buildDataList([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}]);
let url = 'https://api.apidash.dev/io/form';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "multipart/form-data; boundary=test"
  },
  body: 
payload
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost4, "https",
              boundary: "test"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fileInput.files[0],value);
      }
    }
  return formdata;
}

const payload = buildDataList([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}]);
let url = 'https://api.apidash.dev/io/form';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "multipart/form-data; boundary=test",
    "User-Agent": "Test Agent"
  },
  body: 
payload
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost5, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fileInput.files[0],value);
      }
    }
  return formdata;
}

const payload = buildDataList([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}]);
let url = 'https://api.apidash.dev/io/img';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "multipart/form-data; boundary=test"
  },
  body: 
payload
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost6, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fileInput.files[0],value);
      }
    }
  return formdata;
}

const payload = buildDataList([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}]);
let url = 'https://api.apidash.dev/io/img';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "multipart/form-data; boundary=test"
  },
  body: 
payload
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost7, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fileInput.files[0],value);
      }
    }
  return formdata;
}

const payload = buildDataList([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}]);
let url = 'https://api.apidash.dev/io/form?size=2&len=3';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "multipart/form-data; boundary=test"
  },
  body: 
payload
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost8, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fileInput.files[0],value);
      }
    }
  return formdata;
}

const payload = buildDataList([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}]);
let url = 'https://api.apidash.dev/io/img?size=2&len=3';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "multipart/form-data; boundary=test",
    "User-Agent": "Test Agent",
    "Keep-Alive": "true"
  },
  body: 
payload
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPost9, "https",
              boundary: "test"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""let url = 'https://reqres.in/api/users/2';

let options = {
  method: 'PUT',
  headers: {
    "Content-Type": "application/json"
  },
  body: 
"{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}"
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""let url = 'https://reqres.in/api/users/2';

let options = {
  method: 'PATCH',
  headers: {
    "Content-Type": "application/json"
  },
  body: 
"{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""let url = 'https://reqres.in/api/users/2';

let options = {
  method: 'DELETE'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.jsFetch, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""let url = 'https://reqres.in/api/users/2';

let options = {
  method: 'DELETE',
  headers: {
    "Content-Type": "application/json"
  },
  body: 
"{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.jsFetch, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
