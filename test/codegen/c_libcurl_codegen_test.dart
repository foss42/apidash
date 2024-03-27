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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/country/data?code=US");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/country/data?code=US&code=IND");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash?raw=true");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash?raw=true");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social?num=8700000&add_space=true");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

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
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social?num=8700000&digits=3");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");

    struct curl_slist *headers = NULL;
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

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"text\":\"I LOVE Flutter\",\"flag\":null,\"male\":true,\"female\":false,\"no\":1.2,\"arr\":[\"null\",\"true\",\"false\",null]}");

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

    test('POST 4', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/form");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

  struct curl_httppost *formpost = NULL;
  struct curl_httppost *lastptr = NULL;
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "text", CURLFORM_COPYCONTENTS, "API", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "sep", CURLFORM_COPYCONTENTS, "|", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "times", CURLFORM_COPYCONTENTS, "3", CURLFORM_END);
  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost4, "https"), expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/form");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

  struct curl_httppost *formpost = NULL;
  struct curl_httppost *lastptr = NULL;
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "text", CURLFORM_COPYCONTENTS, "API", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "sep", CURLFORM_COPYCONTENTS, "|", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "times", CURLFORM_COPYCONTENTS, "3", CURLFORM_END);
  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

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
      expect(cLibcurlCodeGen.getCode(requestModelPost5, "https"), expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/img");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

  struct curl_httppost *formpost = NULL;
  struct curl_httppost *lastptr = NULL;
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "token", CURLFORM_COPYCONTENTS, "xyz", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "imfile", CURLFORM_FILE, "/Documents/up/1.png", CURLFORM_END);
  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost6, "https"), expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/img");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"text\":\"I LOVE Flutter\"}");

  struct curl_httppost *formpost = NULL;
  struct curl_httppost *lastptr = NULL;
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "token", CURLFORM_COPYCONTENTS, "xyz", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "imfile", CURLFORM_FILE, "/Documents/up/1.png", CURLFORM_END);
  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost7, "https"), expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/form?size=2&len=3");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

  struct curl_httppost *formpost = NULL;
  struct curl_httppost *lastptr = NULL;
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "text", CURLFORM_COPYCONTENTS, "API", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "sep", CURLFORM_COPYCONTENTS, "|", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "times", CURLFORM_COPYCONTENTS, "3", CURLFORM_END);
  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPost8, "https"), expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/img?size=2&len=3");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "User-Agent: Test Agent");
    headers = curl_slist_append(headers, "Keep-Alive: true");
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"text\":\"I LOVE Flutter\"}");

  struct curl_httppost *formpost = NULL;
  struct curl_httppost *lastptr = NULL;
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "token", CURLFORM_COPYCONTENTS, "xyz", CURLFORM_END);
  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "imfile", CURLFORM_FILE, "/Documents/up/1.png", CURLFORM_END);
  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

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
      expect(cLibcurlCodeGen.getCode(requestModelPost9, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
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
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"name\":\"morpheus\",\"job\":\"zion resident\"}");

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
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
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PATCH");

    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"name\":\"marfeus\",\"job\":\"accountant\"}");

    res = curl_easy_perform(curl);
    if(res != CURLE_OK) {
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    }

    curl_easy_cleanup(curl);
  }

  return 0;
}
""";
      expect(cLibcurlCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
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
