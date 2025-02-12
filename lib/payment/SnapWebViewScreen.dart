import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapWebViewScreen extends StatefulWidget {
  final String snapUrl; // URL dari Midtrans Snap

  const SnapWebViewScreen({required this.snapUrl, Key? key}) : super(key: key);

  @override
  _SnapWebViewScreenState createState() => _SnapWebViewScreenState();
}

class _SnapWebViewScreenState extends State<SnapWebViewScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  // Inisialisasi controller secara asinkron dan update state setelah siap.
  Future<void> _initializeController() async {
    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            print("🔄 Halaman selesai dimuat: $url");
          },
          onNavigationRequest: (request) {
            if (request.url.contains('status=success')) {
              // Jika URL mengandung status=success, kembali ke halaman sebelumnya
              Navigator.pop(context, 'success');
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    await controller.loadRequest(Uri.parse(widget.snapUrl));

    // Setelah controller siap, update state
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller!),
    );
  }
}
