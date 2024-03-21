import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/country/data?code=US");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/country/data?code=IND");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash?raw=true");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.github.com/repos/foss42/apidash?raw=true");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social?num=8700000&add_space=true");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
            CodegenLanguage.cCurlCodeGen,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social?num=8700000&digits=3");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/humanize/social");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD");
    curl_easy_setopt(curl, CURLOPT_URL, "http://api.apidash.dev");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/case/lower");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"Content-Type: text/plain"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
    const char *data = "{
"text": "I LOVE Flutter"
}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/case/lower");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"Content-Type: application/json"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
    const char *data = "{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/case/lower");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent");   
    headers = curl_slist_append(headers,"Content-Type: application/json"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
    const char *data = "{
"text": "I LOVE Flutter"
}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/form");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "text");    
    curl_mime_data(part, "API", CURL_ZERO_TERMINATED);
    
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "sep");    
    curl_mime_data(part, "|", CURL_ZERO_TERMINATED);
    
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "times");    
    curl_mime_data(part, "3", CURL_ZERO_TERMINATED);
    
          
    curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
    res = curl_easy_perform(curl);
    curl_mime_free(mime);
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/form");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "text");    
    curl_mime_data(part, "API", CURL_ZERO_TERMINATED);
    
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "sep");    
    curl_mime_data(part, "|", CURL_ZERO_TERMINATED);
    
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "times");    
    curl_mime_data(part, "3", CURL_ZERO_TERMINATED);
    
          
    curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
    res = curl_easy_perform(curl);
    curl_mime_free(mime);
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost5, "https"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/img");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "token");    
    curl_mime_data(part, "xyz", CURL_ZERO_TERMINATED);
    
    
    part = curl_mime_addpart(mime);
    curl_mime_name(part, "imfile");
    curl_mime_filedata(part, "/Documents/up/1.png");
    
          
    curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
    res = curl_easy_perform(curl);
    curl_mime_free(mime);
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost6, "https"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/img");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "token");    
    curl_mime_data(part, "xyz", CURL_ZERO_TERMINATED);
    
    
    part = curl_mime_addpart(mime);
    curl_mime_name(part, "imfile");
    curl_mime_filedata(part, "/Documents/up/1.png");
    
          
    curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
    res = curl_easy_perform(curl);
    curl_mime_free(mime);
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost7, "https"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/form?size=2&len=3");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "text");    
    curl_mime_data(part, "API", CURL_ZERO_TERMINATED);
    
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "sep");    
    curl_mime_data(part, "|", CURL_ZERO_TERMINATED);
    
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "times");    
    curl_mime_data(part, "3", CURL_ZERO_TERMINATED);
    
          
    curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
    res = curl_easy_perform(curl);
    curl_mime_free(mime);
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost8, "https"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_easy_setopt(curl, CURLOPT_URL, "https://api.apidash.dev/io/img?size=2&len=3");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"User-Agent: Test Agent");   
    headers = curl_slist_append(headers,"Keep-Alive: true"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
      
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "token");    
    curl_mime_data(part, "xyz", CURL_ZERO_TERMINATED);
    
    
    part = curl_mime_addpart(mime);
    curl_mime_name(part, "imfile");
    curl_mime_filedata(part, "/Documents/up/1.png");
    
          
    curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);
    res = curl_easy_perform(curl);
    curl_mime_free(mime);
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"Content-Type: application/json"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
    const char *data = "{
"name": "morpheus",
"job": "zion resident"
}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PATCH");
    curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"Content-Type: application/json"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
    const char *data = "{
"name": "marfeus",
"job": "accountant"
}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
      
    
    res = curl_easy_perform(curl);
    
    
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE");
    curl_easy_setopt(curl, CURLOPT_URL, "https://reqres.in/api/users/2");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;    
    headers = curl_slist_append(headers,"Content-Type: application/json"); 
   
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
    const char *data = "{
"name": "marfeus",
"job": "accountant"
}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    
      
    
    res = curl_easy_perform(curl);
    
    curl_slist_free_all(headers);
  }
  curl_easy_cleanup(curl);
  return 0;
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.cCurlCodeGen, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
