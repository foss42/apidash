import 'package:flutter/material.dart';
import 'package:webview_cef/webview_cef.dart';

class HtmlPreviewer extends StatefulWidget {
  const HtmlPreviewer({super.key, required this.url});
  final String url;

  @override
  _HtmlPreviewerState createState() => _HtmlPreviewerState();
}

class _HtmlPreviewerState extends State<HtmlPreviewer> {
  final WebViewController _controller = WebViewController();
  final _textController = TextEditingController();
  String title = "";
  Future<void> initPlatformState() async {
    _textController.text = widget.url;
    await _controller.initialize();
    await _controller.loadUrl(widget.url);
    _controller.setWebviewListener(WebviewEventsListener(
      onTitleChanged: (t) {
        setState(() {
          title = t;
        });
      },
      onUrlChanged: (url) {
        _textController.text = url;
      },
    ));

    // ignore: prefer_collection_literals
    final Set<JavascriptChannel> jsChannels = [
      JavascriptChannel(
          name: 'Print',
          onMessageReceived: (JavascriptMessage message) {
            _controller.sendJavaScriptChannelCallBack(
                false,
                "{'code':'200','message':'print succeed!'}",
                message.callbackId,
                message.frameId);
          }),
    ].toSet();

    await _controller.setJavaScriptChannels(jsChannels);

    await _controller.executeJavaScript("function abc(e){console.log(e)}");

    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: WebView(_controller));
  }
}
