import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tnt/widgets/app_loader.dart';

class AddPostWebView extends StatefulWidget {
  const AddPostWebView({super.key});

  @override
  State<AddPostWebView> createState() => _AddPostWebViewState();
}

class _AddPostWebViewState extends State<AddPostWebView> {
  InAppWebViewController? webViewController;
  bool _isReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://technewstips.com/post-your-blog/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false, // ✅ video autoplay
              allowsInlineMediaPlayback: true, // ✅ inline video
              allowFileAccessFromFileURLs: true, // ✅ file picker
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
  await controller.evaluateJavascript(source: """
    setTimeout(function() {
      var header = document.querySelector('header');
      if (header) header.style.display = 'none';
      var footer = document.querySelector('footer');
      if (footer) footer.style.display = 'none';
    }, 500); // delay 0.5s to ensure DOM is ready
  """);

  setState(() => _isReady = true);
},

            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri.toString() == "https://technewstips.com/post-your-blog/") {
                return NavigationActionPolicy.ALLOW;
              }
              return NavigationActionPolicy.CANCEL; // ✅ block others
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
