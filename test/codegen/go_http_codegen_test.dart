import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev")
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/country/data")
  query := url.Query()
  
  query.Set("code", "US")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/country/data?code=US")
  query := url.Query()
  
  query.Set("code", "IND")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/humanize/social")
  query := url.Query()
  
  query.Set("num", "8700000")
  query.Set("digits", "3")
  query.Set("system", "SS")
  query.Set("add_space", "true")
  query.Set("trailing_zeros", "true")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.github.com/repos/foss42/apidash")
  req, _ := http.NewRequest("GET", url.String(), nil)

  req.Header.Set("User-Agent", "Test Agent")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.github.com/repos/foss42/apidash")
  query := url.Query()
  
  query.Set("raw", "true")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  req.Header.Set("User-Agent", "Test Agent")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev")
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.github.com/repos/foss42/apidash")
  query := url.Query()
  
  query.Set("raw", "true")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  req.Header.Set("User-Agent", "Test Agent")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/humanize/social")
  query := url.Query()
  
  query.Set("num", "8700000")
  query.Set("add_space", "true")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/humanize/social")
  req, _ := http.NewRequest("GET", url.String(), nil)

  req.Header.Set("User-Agent", "Test Agent")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(
          codegen.getCode(
            CodegenLanguage.goHttp,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/humanize/social")
  query := url.Query()
  
  query.Set("num", "8700000")
  query.Set("digits", "3")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("GET", url.String(), nil)

  req.Header.Set("User-Agent", "Test Agent")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/humanize/social")
  req, _ := http.NewRequest("GET", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev")
  req, _ := http.NewRequest("HEAD", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("http://api.apidash.dev")
  req, _ := http.NewRequest("HEAD", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/case/lower")
  payload := bytes.NewBuffer([]byte(`{
"text": "I LOVE Flutter"
}`))
  req, _ := http.NewRequest("POST", url.String(), payload)

  req.Header.Set("Content-Type", "text/plain")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/case/lower")
  payload := bytes.NewBuffer([]byte(`{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}`))
  req, _ := http.NewRequest("POST", url.String(), payload)

  req.Header.Set("Content-Type", "application/json")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/case/lower")
  payload := bytes.NewBuffer([]byte(`{
"text": "I LOVE Flutter"
}`))
  req, _ := http.NewRequest("POST", url.String(), payload)

  req.Header.Set("User-Agent", "Test Agent")
  req.Header.Set("Content-Type", "application/json")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
  "mime/multipart"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/io/form")
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload)
  
  writer.WriteField("text", "API")
  writer.WriteField("sep", "|")
  writer.WriteField("times", "3")
  writer.Close()

  req, _ := http.NewRequest("POST", url.String(), payload)
  req.Header.Set("Content-Type", writer.FormDataContentType())

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
  "mime/multipart"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/io/form")
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload)
  
  writer.WriteField("text", "API")
  writer.WriteField("sep", "|")
  writer.WriteField("times", "3")
  writer.Close()

  req, _ := http.NewRequest("POST", url.String(), payload)

  req.Header.Set("User-Agent", "Test Agent")
  req.Header.Set("Content-Type", writer.FormDataContentType())

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelPost5, "https"),
          expectedCode);
    });
  });

  test("POST 6", () {
    const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
  "mime/multipart"
  "os"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/io/img")
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload)
  var (
    file *os.File
    part io.Writer
  )
  
  writer.WriteField("token", "xyz")
  file, _ = os.Open("/Documents/up/1.png")
  defer file.Close()
  part, _ = writer.CreateFormFile("imfile", "/Documents/up/1.png")
  io.Copy(part, file)
  
  writer.Close()

  req, _ := http.NewRequest("POST", url.String(), payload)
  req.Header.Set("Content-Type", writer.FormDataContentType())

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
    expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelPost6, "https"),
        expectedCode);
  });
  test("POST 7", () {
    const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
  "mime/multipart"
  "os"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/io/img")
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload)
  var (
    file *os.File
    part io.Writer
  )
  
  writer.WriteField("token", "xyz")
  file, _ = os.Open("/Documents/up/1.png")
  defer file.Close()
  part, _ = writer.CreateFormFile("imfile", "/Documents/up/1.png")
  io.Copy(part, file)
  
  writer.Close()

  req, _ := http.NewRequest("POST", url.String(), payload)
  req.Header.Set("Content-Type", writer.FormDataContentType())

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
    expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelPost7, "https"),
        expectedCode);
  });
  test("POST 8", () {
    const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
  "mime/multipart"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/io/form")
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload)
  
  writer.WriteField("text", "API")
  writer.WriteField("sep", "|")
  writer.WriteField("times", "3")
  writer.Close()

  query := url.Query()
  
  query.Set("size", "2")
  query.Set("len", "3")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("POST", url.String(), payload)
  req.Header.Set("Content-Type", writer.FormDataContentType())

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
    expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelPost8, "https"),
        expectedCode);
  });
  test("POST 9", () {
    const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
  "mime/multipart"
  "os"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://api.apidash.dev/io/img")
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload)
  var (
    file *os.File
    part io.Writer
  )
  
  writer.WriteField("token", "xyz")
  file, _ = os.Open("/Documents/up/1.png")
  defer file.Close()
  part, _ = writer.CreateFormFile("imfile", "/Documents/up/1.png")
  io.Copy(part, file)
  
  writer.Close()

  query := url.Query()
  
  query.Set("size", "2")
  query.Set("len", "3")

  url.RawQuery = query.Encode()
  req, _ := http.NewRequest("POST", url.String(), payload)

  req.Header.Set("User-Agent", "Test Agent")
  req.Header.Set("Keep-Alive", "true")
  req.Header.Set("Content-Type", writer.FormDataContentType())

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
    expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelPost9, "https"),
        expectedCode);
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://reqres.in/api/users/2")
  payload := bytes.NewBuffer([]byte(`{
"name": "morpheus",
"job": "zion resident"
}`))
  req, _ := http.NewRequest("PUT", url.String(), payload)

  req.Header.Set("Content-Type", "application/json")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(codeGen.getCode(CodegenLanguage.goHttp, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://reqres.in/api/users/2")
  payload := bytes.NewBuffer([]byte(`{
"name": "marfeus",
"job": "accountant"
}`))
  req, _ := http.NewRequest("PATCH", url.String(), payload)

  req.Header.Set("Content-Type", "application/json")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://reqres.in/api/users/2")
  req, _ := http.NewRequest("DELETE", url.String(), nil)

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  "bytes"
)

func main() {
  client := &http.Client{}
  url, _ := url.Parse("https://reqres.in/api/users/2")
  payload := bytes.NewBuffer([]byte(`{
"name": "marfeus",
"job": "accountant"
}`))
  req, _ := http.NewRequest("DELETE", url.String(), payload)

  req.Header.Set("Content-Type", "application/json")

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
