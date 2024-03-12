import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev',
  method: 'get'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/country/data',
  method: 'get',
  params: {
    "code": "US"
  }
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/country/data',
  method: 'get',
  params: {
    "code": "IND"
  }
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
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
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.github.com/repos/foss42/apidash',
  method: 'get',
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
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
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev',
  method: 'get'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
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
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  params: {
    "num": "8700000",
    "add_space": "true"
  }
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get',
  headers: {
    "User-Agent": "Test Agent"
  }
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.nodejsAxios,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
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
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/humanize/social',
  method: 'get'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev',
  method: 'head'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'http://api.apidash.dev',
  method: 'head'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/case/lower',
  method: 'post',
  headers: {
    "Content-Type": "text/plain"
  },
  data: "{\n\"text\": \"I LOVE Flutter\"\n}"
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/case/lower',
  method: 'post',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}"
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.apidash.dev/case/lower',
  method: 'post',
  headers: {
    "Content-Type": "application/json",
    "User-Agent": "Test Agent"
  },
  data: "{\n\"text\": \"I LOVE Flutter\"\n}"
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""import axios from 'axios';

const fs = require('fs');

async function buildFormData(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fs.createReadStream(value));
      }
    }
  return formdata;
}

let config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: buildFormData([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}]);
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import axios from 'axios';

const fs = require('fs');

async function buildFormData(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fs.createReadStream(value));
      }
    }
  return formdata;
}

let config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data",
    "User-Agent": "Test Agent"
  },
  data: buildFormData([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}]);
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost5, "https"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""import axios from 'axios';

const fs = require('fs');

async function buildFormData(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fs.createReadStream(value));
      }
    }
  return formdata;
}

let config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: buildFormData([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}]);
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost6, "https"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""import axios from 'axios';

const fs = require('fs');

async function buildFormData(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fs.createReadStream(value));
      }
    }
  return formdata;
}

let config = {
  url: 'https://api.apidash.dev/io/img',
  method: 'post',
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: buildFormData([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}]);
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost7, "https"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""import axios from 'axios';

const fs = require('fs');

async function buildFormData(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fs.createReadStream(value));
      }
    }
  return formdata;
}

let config = {
  url: 'https://api.apidash.dev/io/form',
  method: 'post',
  params: {
    "size": "2",
    "len": "3"
  },
  headers: {
    "Content-Type": "multipart/form-data"
  },
  data: buildFormData([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}]);
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost8, "https"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""import axios from 'axios';

const fs = require('fs');

async function buildFormData(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name, fs.createReadStream(value));
      }
    }
  return formdata;
}

let config = {
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
  data: buildFormData([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}]);
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://reqres.in/api/users/2',
  method: 'put',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}"
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://reqres.in/api/users/2',
  method: 'patch',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://reqres.in/api/users/2',
  method: 'delete'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://reqres.in/api/users/2',
  method: 'delete',
  headers: {
    "Content-Type": "application/json"
  },
  data: "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
