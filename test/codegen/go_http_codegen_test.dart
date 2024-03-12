import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/code_pane.dart';
import 'package:test/test.dart';
import '../request_models.dart';

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
  url, err := url.Parse("https://api.apidash.dev")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/country/data")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("code", "US")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/country/data?code=US")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("code", "IND")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/humanize/social")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("num", "8700000")
  
  query.Set("digits", "3")
  
  query.Set("system", "SS")
  
  query.Set("add_space", "true")
  
  query.Set("trailing_zeros", "true")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.github.com/repos/foss42/apidash")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.github.com/repos/foss42/apidash")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("raw", "true")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.github.com/repos/foss42/apidash")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("raw", "true")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/humanize/social")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("num", "8700000")
  
  query.Set("add_space", "true")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/humanize/social")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/humanize/social")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("num", "8700000")
  
  query.Set("digits", "3")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/humanize/social")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("GET", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("HEAD", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("http://api.apidash.dev")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("HEAD", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/case/lower")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := bytes.NewBuffer([]byte(`{
"text": "I LOVE Flutter"
}`))
  req, err := http.NewRequest("POST", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/case/lower")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := bytes.NewBuffer([]byte(`{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}`))
  req, err := http.NewRequest("POST", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/case/lower")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := bytes.NewBuffer([]byte(`{
"text": "I LOVE Flutter"
}`))
  req, err := http.NewRequest("POST", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  
)

func main() {
  client := &http.Client{}
  url, err := url.Parse("https://api.apidash.dev/io/form")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("POST", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  
)

func main() {
  client := &http.Client{}
  url, err := url.Parse("https://api.apidash.dev/io/form")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("POST", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  
)

func main() {
  client := &http.Client{}
  url, err := url.Parse("https://api.apidash.dev/io/img")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("POST", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/io/img")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := &bytes.Buffer{}
  writer := multipart.NewWriter(body)
  var (
    file *os.File
    part io.Writer
  )
  
  writer.WriteField("token", "xyz")
  file, err = os.Open("/Documents/up/1.png")
  if err != nil {
    fmt.Println(err)
    return
  }
  defer file.Close()

  part, err = writer.CreateFormFile("imfile", "/Documents/up/1.png")
  if err != nil {
    fmt.Println(err)
    return
  }
  io.Copy(part, file)
  
  writer.Close()

  req, err := http.NewRequest("POST", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  
)

func main() {
  client := &http.Client{}
  url, err := url.Parse("https://api.apidash.dev/io/form")
  if err != nil {
    fmt.Println(err)
    return
  }
  query := url.Query()
  
  query.Set("size", "2")
  
  query.Set("len", "3")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("POST", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://api.apidash.dev/io/img")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := &bytes.Buffer{}
  writer := multipart.NewWriter(body)
  var (
    file *os.File
    part io.Writer
  )
  
  writer.WriteField("token", "xyz")
  file, err = os.Open("/Documents/up/1.png")
  if err != nil {
    fmt.Println(err)
    return
  }
  defer file.Close()

  part, err = writer.CreateFormFile("imfile", "/Documents/up/1.png")
  if err != nil {
    fmt.Println(err)
    return
  }
  io.Copy(part, file)
  
  writer.Close()

  query := url.Query()
  
  query.Set("size", "2")
  
  query.Set("len", "3")
  
  url.RawQuery = query.Encode()
  req, err := http.NewRequest("POST", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }

  req.Header.Set("User-Agent", "Test Agent")

  req.Header.Set("Keep-Alive", "true")

  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://reqres.in/api/users/2")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := bytes.NewBuffer([]byte(`{
"name": "morpheus",
"job": "zion resident"
}`))
  req, err := http.NewRequest("PUT", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://reqres.in/api/users/2")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := bytes.NewBuffer([]byte(`{
"name": "marfeus",
"job": "accountant"
}`))
  req, err := http.NewRequest("PATCH", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://reqres.in/api/users/2")
  if err != nil {
    fmt.Println(err)
    return
  }
  req, err := http.NewRequest("DELETE", url.String(), nil)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
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
  url, err := url.Parse("https://reqres.in/api/users/2")
  if err != nil {
    fmt.Println(err)
    return
  }
  body := bytes.NewBuffer([]byte(`{
"name": "marfeus",
"job": "accountant"
}`))
  req, err := http.NewRequest("DELETE", url.String(), body)
  if err != nil {
    fmt.Println(err)
    return
  }
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
}''';
      expect(
          codeGen.getCode(CodegenLanguage.goHttp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
