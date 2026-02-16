import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const TaxiWebViewApp());
}

class TaxiWebViewApp extends StatelessWidget {
  const TaxiWebViewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Sri Lanka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaxiWebView(),
    );
  }
}

class TaxiWebView extends StatefulWidget {
  const TaxiWebView({Key? key}) : super(key: key);

  @override
  State<TaxiWebView> createState() => _TaxiWebViewState();
}

class _TaxiWebViewState extends State<TaxiWebView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://taxisrilanka.com/"))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // Loading Indicator
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
