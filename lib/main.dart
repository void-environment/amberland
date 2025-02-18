// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' ;

void main()  { 
  runApp(const MaterialApp(home: WebViewPage())); 
  
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  late WebViewController controller;
  
  @override
  void initState() {
    
  
  controller = WebViewController()
    
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..addJavaScriptChannel(
        'LoadMedia',
        onMessageReceived: (JavaScriptMessage message) {}
    )
      
    ..setNavigationDelegate(
      NavigationDelegate(

        onProgress: (int progress) {},
        onPageStarted: (String url) {
          isLoading.value = true;
        },
        onPageFinished: (String url) {
          isLoading.value = false;
        },
        
        onWebResourceError: (WebResourceError error) {},

        onNavigationRequest: (NavigationRequest request) async {
          
          if (request.url.startsWith('')) return NavigationDecision.navigate;

          return NavigationDecision.prevent;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://amberland-water.com/app-shop/'));
    super.initState();
    
  }

  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false; 
    }
    return true;
  }

  @override
  
  Widget build(BuildContext context) {
  
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 12, 64, 119),
          toolbarHeight: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                controller.loadRequest(Uri.parse('https://amberland-water.com/app-shop/'));
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, loading, child) {
                return loading
                    ? Container(
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                 )
                : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}