import 'package:apidash/codegen/go/nethttp.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final goNetHttpCodeGen = GoNetHttpCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com/country/data?code=US"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com/country/data?code=IND"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.github.com/repos/foss42/apidash"
	method := "GET"
	headers := map[string]string{
		"User-Agent": "Test Agent",
	}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.github.com/repos/foss42/apidash?raw=true"
	method := "GET"
	headers := map[string]string{
		"User-Agent": "Test Agent",
	}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.github.com/repos/foss42/apidash?raw=true"
	method := "GET"
	headers := map[string]string{
		"User-Agent": "Test Agent",
	}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com/humanize/social?num=8700000&add_space=true"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com/humanize/social"
	method := "GET"
	headers := map[string]string{
		"User-Agent": "Test Agent",
	}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(
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
)

func main() {
	url := "https://api.foss42.com/humanize/social?num=8700000&digits=3"
	method := "GET"
	headers := map[string]string{
		"User-Agent": "Test Agent",
	}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com/humanize/social"
	method := "GET"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com"
	method := "HEAD"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://api.foss42.com"
	method := "HEAD"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	url := "https://api.foss42.com/case/lower"
	method := "POST"
	headers := map[string]string{
		"Content-Type": "text/plain",
	}
	body := strings.NewReader(`{
"text": "I LOVE Flutter"
}`)

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";

      expect(
          goNetHttpCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	url := "https://api.foss42.com/case/lower"
	method := "POST"
	headers := map[string]string{
		"Content-Type": "application/json",
	}
	body := strings.NewReader(`{
"text": "I LOVE Flutter"
}`)

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	url := "https://api.foss42.com/case/lower"
	method := "POST"
	headers := map[string]string{
		"Content-Type": "application/json",
		"User-Agent": "Test Agent",
	}
	body := strings.NewReader(`{
"text": "I LOVE Flutter"
}`)

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	url := "https://reqres.in/api/users/2"
	method := "PUT"
	headers := map[string]string{
		"Content-Type": "application/json",
	}
	body := strings.NewReader(`{
"name": "morpheus",
"job": "zion resident"
}`)

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(goNetHttpCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	url := "https://reqres.in/api/users/2"
	method := "PATCH"
	headers := map[string]string{
		"Content-Type": "application/json",
	}
	body := strings.NewReader(`{
"name": "marfeus",
"job": "accountant"
}`)

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	url := "https://reqres.in/api/users/2"
	method := "DELETE"
	headers := map[string]string{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	url := "https://reqres.in/api/users/2"
	method := "DELETE"
	headers := map[string]string{
		"Content-Type": "application/json",
	}
	body := strings.NewReader(`{
"name": "marfeus",
"job": "accountant"
}`)

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	// Make the HTTP request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("%s\n%s\n\n", resp.Status, resp.Header)

	// Read and print the response
	bodyText, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}
	fmt.Println(string(bodyText))
}
""";
      expect(
          goNetHttpCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
