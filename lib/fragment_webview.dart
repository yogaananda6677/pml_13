import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'global_variables.dart';

class FragmentWebView extends StatefulWidget {
  const FragmentWebView({super.key});

  @override
  State<FragmentWebView> createState() => FragmentWebViewState();
}

class FragmentWebViewState extends State<FragmentWebView> {
  late final WebViewController controller;
  int _loadingProgress = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    webSettings();
    if (GlobalVariables.url.isNotEmpty) {
      final uri = Uri.tryParse(GlobalVariables.url);
      if (uri != null) {
        controller.loadRequest(uri);
      }
    }
  }

  /// Inisiasi setting webview matching Kotlin webSettings()
  void webSettings() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Gunakan User-Agent Chrome Mobile standar tanpa tanda '; wv'
      // agar situs seperti TikTok tidak menganggap ini in-app webview terbatas
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.tryParse(request.url);
            final scheme = uri?.scheme.toLowerCase() ?? '';

            // Hanya izinkan navigasi untuk http, https, dan data URI di dalam webview
            if (scheme == 'http' || scheme == 'https' || scheme == 'data') {
              return NavigationDecision.navigate;
            }

            // Cegah skema aplikasi eksternal (misal tiktok://, snssdk1233://, intent://, market://)
            // yang memicu "net::ERR_UNKNOWN_URL_SCHEME / Halaman web tidak tersedia" pada WebView
            debugPrint('Blocked unsupported deep link scheme: ${request.url}');
            return NavigationDecision.prevent;
          },
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
                _isLoading = progress < 100;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              'WebResourceError: ${error.description} (code: ${error.errorCode})',
            );
          },
        ),
      );

    // Pengaturan platform Android yang sesuai dengan WebSettings di Kotlin
    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
      androidController.setAllowFileAccess(true);
      androidController.setAllowContentAccess(true);
      androidController.setGeolocationEnabled(true);
      androidController.setUseWideViewPort(true);
    }
  }

  void loadUrl(String url) {
    GlobalVariables.url = url;
    final uri = Uri.tryParse(url);
    if (uri != null) {
      controller.loadRequest(uri);
    }
  }

  Future<bool> canGoBack() async {
    return await controller.canGoBack();
  }

  Future<void> goBack() async {
    await controller.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            LinearProgressIndicator(
              value: _loadingProgress > 0 ? _loadingProgress / 100.0 : null,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF105B50)),
              minHeight: 3,
            ),
        ],
      ),
    );
  }
}
