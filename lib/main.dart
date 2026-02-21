import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  runApp(const TaxiWebViewApp());
}

class TaxiWebViewApp extends StatelessWidget {
  const TaxiWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaxiWebView(),
    );
  }
}

class TaxiWebView extends StatefulWidget {
  const TaxiWebView({super.key});

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
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;

            if (url.startsWith("tel:") ||
                url.startsWith("mailto:") ||
                url.startsWith("whatsapp:") ||
                url.contains("wa.me")) {
              final uri = Uri.parse(url);
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse("https://taxisrilanka.com/"));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
