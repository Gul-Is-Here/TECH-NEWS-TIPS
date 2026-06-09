import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tnt/widgets/app_loader.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  InAppWebViewController? webViewController;
  bool _isReady = false;

  Future<void> _hideHeaderFooter(InAppWebViewController controller) async {
    // Run JS to hide header/footer and return a signal when done
    await controller.evaluateJavascript(source: """
      new Promise((resolve) => {
        setTimeout(() => {
          var header = document.querySelector('header');
          if (header) header.style.display = 'none';
          var footer = document.querySelector('footer');
          if (footer) footer.style.display = 'none';
          resolve(true);
        }, 500); // wait DOM
      });
    """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://technewstips.com/about-us/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              useShouldOverrideUrlLoading: true,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (_, __) {
              setState(() => _isReady = false);
            },
            onLoadStop: (controller, url) async {
              await _hideHeaderFooter(controller);
              setState(() => _isReady = true); // ✅ now only after header/footer removed
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri.toString() == "https://technewstips.com/about-us/") {
                return NavigationActionPolicy.ALLOW;
              }
              return NavigationActionPolicy.CANCEL;
            },
          ),
          if (!_isReady)
            const Center(
              child: AppLoader(),
            ),
        ],
      ),
    );
  }
}
