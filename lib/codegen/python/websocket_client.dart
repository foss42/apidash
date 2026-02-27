import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class PythonWebSocketCodeGen {
  final String kTemplateStart = """import websocket
import threading
import time

url = '{{url}}'

""";

  String kTemplateHeaders = """

headers = {{headers}}

""";

  String kTemplateRequest = """
def on_message(ws, message):
    print(f"Received: {message}")

def on_error(ws, error):
    print(f"Error: {error}")

def on_close(ws, close_status_code, close_msg):
    print("### closed ###")

def on_open(ws):
    print("WebSocket connected")
    # You can send messages here
    # ws.send("Hello, Server!")

if __name__ == "__main__":
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(url,
                              on_open=on_open,
                              on_message=on_message,
                              on_error=on_error,
                              on_close=on_close{% if hasHeaders %},
                              header=headers{% endif %})

    ws.run_forever()
""";

  String? getCode(
    WebSocketRequestModel requestModel,
  ) {
    try {
      String result = "";
      bool hasHeaders = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": uri.toString(),
        });

        var headersList = requestModel.enabledHeaders;
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty) {
            hasHeaders = true;
            var headersString = kJsonEncoder.convert(headers);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString});
          }
        }

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "hasHeaders": hasHeaders,
        });
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
