import 'package:apidash/codegen/js/fetch.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final fetchCodeGen = FetchCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""let url = 'https://api.foss42.com';

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
      expect(fetchCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/country/data?code=US';

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
      expect(fetchCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/country/data?code=IND';

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
      expect(fetchCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true';

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
      expect(fetchCodeGen.getCode(requestModelGet4, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelGet5, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""let url = 'https://api.foss42.com';

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
      expect(fetchCodeGen.getCode(requestModelGet7, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/humanize/social?num=8700000&add_space=true';

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
      expect(fetchCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/humanize/social';

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
          fetchCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/humanize/social?num=8700000&digits=3';

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
      expect(fetchCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode =
          r"""let url = 'https://api.foss42.com/humanize/social';

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
      expect(fetchCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""let url = 'https://api.foss42.com';

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
      expect(fetchCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""let url = 'http://api.foss42.com';

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
      expect(fetchCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""let url = 'https://api.foss42.com/case/lower';

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
      expect(fetchCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""let url = 'https://api.foss42.com/case/lower';

let options = {
  method: 'POST',
  headers: {
    "Content-Type": "application/json"
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
      expect(fetchCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""let url = 'https://api.foss42.com/case/lower';

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
      expect(fetchCodeGen.getCode(requestModelPost3, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelPut1, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
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
      expect(fetchCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
