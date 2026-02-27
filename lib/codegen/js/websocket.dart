import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class JsWebSocketCodeGen {
  final String kTemplateStart = """const url = '{{url}}';

""";

  String kTemplateRequest = """
const ws = new WebSocket(url);

ws.onopen = function() {
    console.log("WebSocket connected");
    // You can send messages here
    // ws.send("Hello, Server!");
};

ws.onmessage = function(event) {
    console.log(`Received: \${event.data}`);
};

ws.onerror = function(error) {
    console.error("WebSocket Error:", error);
};

ws.onclose = function(event) {
    console.log("WebSocket closed with code:", event.code);
};
""";

  String? getCode(
    WebSocketRequestModel requestModel,
  ) {
    try {
      String result = "";

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

        // Browsers do not support custom WS headers out of the box (except subprotocols).
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({});
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
