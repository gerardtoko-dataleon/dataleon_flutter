import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

typedef DataleonResultCallback = void Function(String status, [String? error]);

class DataleonWebView extends StatefulWidget {
  final String sessionUrl;
  final DataleonResultCallback onResult;
  final VoidCallback? onClose;

  const DataleonWebView({
    super.key,
    required this.sessionUrl,
    required this.onResult,
    this.onClose,
  });

  @override
  State<DataleonWebView> createState() => _DataleonWebViewState();
}

class _DataleonWebViewState extends State<DataleonWebView> {
  bool _loading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'DataleonNative',
        onMessageReceived: (msg) {
          debugPrint("📩 JS → Flutter: ${msg.message}");
          _handleMessage(msg.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            setState(() => _loading = false);

            // 🔹 Injection du bridge JS pour capturer postMessage
            await _controller.runJavaScript('''
              (function() {
                window.addEventListener("message", function(e) {
                  if (window.DataleonNative && typeof window.DataleonNative.postMessage === "function") {
                    window.DataleonNative.postMessage(e.data);
                  }
                });

                // Redéfinition window.parent.postMessage
                var originalPostMessage = window.parent.postMessage;
                window.parent.postMessage = function(message, targetOrigin) {
                  if (window.DataleonNative && typeof window.DataleonNative.postMessage === "function") {
                    window.DataleonNative.postMessage(message);
                  } else {
                    originalPostMessage(message, targetOrigin);
                  }
                };

                console.log("✅ Dataleon JS bridge injected");
              })();
            ''');
          },
          onNavigationRequest: (request) {
            _handleNavChange(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.sessionUrl));

    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  void _handleNavChange(String url) {
    if (url.contains('status=FINISHED')) {
      widget.onResult("FINISHED");
      widget.onClose?.call();
    } else if (url.contains('status=FAILED')) {
      widget.onResult("FAILED", "Verification failed");
    } else if (url.contains('status=CANCELED')) {
      widget.onResult("CANCELED");
      widget.onClose?.call();
    } else if (url.contains('status=ERROR')) {
      widget.onResult("ERROR", "Navigation error");
    }
  }

  void _handleMessage(String msg) {
    switch (msg) {
      case 'FINISHED':
        widget.onResult("FINISHED");
        widget.onClose?.call();
        break;
      case 'FAILED':
        widget.onResult("FAILED");
        break;
      case 'ABORTED':
        widget.onResult("ABORTED");
        break;
      case 'CANCELED':
        widget.onResult("CANCELED");
        widget.onClose?.call();
        break;
      case 'STARTED':
        widget.onResult("STARTED");
        break;
      default:
        widget.onResult(msg);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
