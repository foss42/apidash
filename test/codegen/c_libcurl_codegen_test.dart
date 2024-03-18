import 'package:apidash/codegen/c/libcurl.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final cLibcurlCodeGen = CLibcurlCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/country/data");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/country/data?code=US");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    headers = curl_slist_append(headers, ": Bearer XYZ");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet10, "https"), expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "http://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/case/lower");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"text\":\"I LOVE Flutter\"}");

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/case/lower");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"text\":\"I LOVE Flutter\"}");

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/case/lower");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"text\":\"I LOVE Flutter\"}");

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });

//     test('POST 4', () {
//       const expectedCode = r"""

// """;
//       expect(cLibcurlCodeGen.getCode(requestModelPost4, "https"), expectedCode);
//     });

//     test('POST 5', () {
//       const expectedCode = r"""

// """;
//       print(cLibcurlCodeGen.getCode(requestModelPost5, "https"));
//       expect(cLibcurlCodeGen.getCode(requestModelPost5, "https"), expectedCode);
//     });

//     test('POST 6', () {
//       const expectedCode = r"""

// """;
//       print(cLibcurlCodeGen.getCode(requestModelPost6, "https"));
//       expect(cLibcurlCodeGen.getCode(requestModelPost6, "https"), expectedCode);
//     });

//     test('POST 7', () {
//       const expectedCode = r"""

// """;
//       print(cLibcurlCodeGen.getCode(requestModelPost7, "https"));
//       expect(cLibcurlCodeGen.getCode(requestModelPost7, "https"), expectedCode);
//     });

//     test('POST 8', () {
//       const expectedCode = r"""

// """;
//       print(cLibcurlCodeGen.getCode(requestModelPost8, "https"));
//       expect(cLibcurlCodeGen.getCode(requestModelPost8, "https"), expectedCode);
//     });

//     test('POST 9', () {
//       const expectedCode = r"""

// """;
//       print(cLibcurlCodeGen.getCode(requestModelPost9, "https"));
//       expect(cLibcurlCodeGen.getCode(requestModelPost9, "https"), expectedCode);
//     });
//   });

//   group('PUT Request', () {
//     test('PUT 1', () {
//       const expectedCode = r"""
// #include <stdio.h>
// #include <stdlib.h>
// #include <curl/curl.h>

// int main() {
//   CURL *curl;
//   CURLcode res;
//   curl = curl_easy_init();

//   if(curl) {
//     curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
//     curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");

//     struct curl_slist *headers = NULL;
//     headers = curl_slist_append(headers, "Content-Type: application/json");
//     curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

//     curl_easy_setopt(curl, CURLOPT_POST, 1L);
//     curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"name\":\"morpheus\",\"job\":\"zion resident\"}");

//     res = curl_easy_perform(curl);
//     if(res != CURLE_OK) {
//       fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
//     }

//     curl_easy_cleanup(curl);
//   }

//   return 0;
// }
// """;
//       expect(cLibcurlCodeGen.getCode(requestModelPut1, "https"), expectedCode);
//     });
//   });

//   group('PATCH Request', () {
//     test('PATCH 1', () {
//       const expectedCode = r"""
// #include <stdio.h>
// #include <stdlib.h>
// #include <curl/curl.h>

// int main() {
//   CURL *curl;
//   CURLcode res;
//   curl = curl_easy_init();

//   if(curl) {
//     curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
//     curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PATCH");

//     struct curl_slist *headers = NULL;
//     headers = curl_slist_append(headers, "Content-Type: application/json");
//     curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

//     curl_easy_setopt(curl, CURLOPT_POST, 1L);
//     curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"name\":\"marfeus\",\"job\":\"accountant\"}");

//     res = curl_easy_perform(curl);
//     if(res != CURLE_OK) {
//       fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
//     }

//     curl_easy_cleanup(curl);
//   }

//   return 0;
// }
// """;
//       expect(cLibcurlCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
//     });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
