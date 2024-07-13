import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Backbutton pressed (device or appbar button), do whatever you want.');
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Web View'),
          // ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onLoadStop: (controller, url) async {
              // Do something when the page finishes loading
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
    );
  }
}
