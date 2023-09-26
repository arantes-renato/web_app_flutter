import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> urls = [
    "url 1",
    "url 2"
  ];
  late final WebViewController controller;
  bool showErrorPage = false;
  int currentUrlIndex = 0;

  void _refreshPage() {
    controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nome do app',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Offstage(
                offstage: showErrorPage,
                child: WebView(
                  initialUrl: urls[currentUrlIndex],
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  },
                  onPageStarted: (url) {
                    setState(() {
                      showErrorPage = false;
                    });
                  },
                  onWebResourceError: (error) {
                    setState(() {
                      showErrorPage = true;
                    });
                    _tryReconnect();
                  },
                ),
              ),
              if (showErrorPage)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _tryReconnect();
                    },
                    child: const Text('Reconectar'),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  color: Colors.white54,
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tryReconnect() {
    if (currentUrlIndex < urls.length - 1) {
      currentUrlIndex++;
    } else {
      currentUrlIndex = 0;
    }
    controller.loadUrl(urls[currentUrlIndex]);
  }
}
