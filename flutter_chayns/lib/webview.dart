import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  WebViewContainer({this.url});
  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  _WebViewContainerState(this._url);
  var _url;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(javascriptMode: JavascriptMode.unrestricted, initialUrl: _url),
    );
  }
}
