import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
	runApp(const MaterialApp(home: WebViewApp()));
}

class WebViewApp extends StatefulWidget {
	const WebViewApp({super.key});

	@override
	State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
	late final WebViewController _controller;

	@override
	void initState() {
		super.initState();

		late final PlatformWebViewControllerCreationParams params;
		if (WebViewPlatform.instance is WebKitWebViewPlatform) {
			params = WebKitWebViewControllerCreationParams(
				allowsInlineMediaPlayback: true,
				mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
			);
		} else {
			params = const PlatformWebViewControllerCreationParams();
		}

		final WebViewController controller =
			WebViewController.fromPlatformCreationParams(params);

		controller
			..setJavaScriptMode(JavaScriptMode.unrestricted)
			..setBackgroundColor(const Color(0x00000000))
			..loadRequest(Uri.parse('https://google.com'));

		if (controller.platform is AndroidWebViewController) {
			AndroidWebViewController.enableDebugging(true);
			(controller.platform as AndroidWebViewController)
				.setMediaPlaybackRequiresUserGesture(false);
		}

		_controller = controller;
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				title: const Text('Flutter WebView'),
			),
			body: WebViewWidget(controller: _controller),
		);
	}
}
