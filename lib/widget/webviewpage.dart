import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:finallinkapp/widget/brokenlink.dart';
import 'package:finallinkapp/widget/nativehelper.dart';
import 'package:finallinkapp/widget/primarybutton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewMini extends StatefulWidget {
  final String url;

  const WebViewMini({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _WebViewMiniState createState() => _WebViewMiniState();
}

class _WebViewMiniState extends State<WebViewMini> {
  InAppWebViewController? ctrl;
  late PullToRefreshController pullToRefreshController;
  String urls = '';

  bool dark = false;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final GlobalKey webViewKey = GlobalKey();
  bool error = false;
  bool error4 = false;

  Future<bool> backbuton(BuildContext context) async {
    if (await ctrl!.canGoBack()) {
      ctrl!.loadUrl(urlRequest: URLRequest(url: Uri.parse(widget.url)));

      return false;
    } else {
      var c = false;
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        barrierDismissible: false,

        // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Close App'),
            content: SingleChildScrollView(
              child: Column(
                children: const <Widget>[
                  Text('Are you sure,You want to exit.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  c = true;
                  Navigator.of(context).pop();
                  exit(0);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return c;
    }
  }

  @override
  void initState() {
    super.initState();
    // s();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          ctrl?.reload();
        }
      },
    );

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) async {
      if (e == ConnectivityResult.none) {
        setState(() {
          error = true;
        });
      } else {
        setState(() {
          error = false;
        });
      }
    });
  }

  int position = 0;
  doneLoading() {}

  startLoading() {}

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  int visit = 0;
  int cIndex = 0;
  final iconLinearGradiant = List<Color>.from([
    const Color.fromARGB(255, 251, 2, 197),
    const Color.fromARGB(255, 72, 3, 80)
  ]);
  double height = 30;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor("#ffffff"),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: HexColor("#ffffff"),
      systemNavigationBarDividerColor: HexColor("#ffffff"),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () => backbuton(context),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          bottomNavigationBar: SweetNavBar(
            // paddingGradientColor: [Colors.white],

            currentIndex: cIndex,
            paddingBackgroundColor: Colors.transparent,
            items: [
              SweetNavBarItem(
                sweetActive: const Icon(Icons.home),
                sweetIcon: const Icon(
                  Icons.home_outlined,
                  color: Color.fromARGB(214, 59, 59, 59),
                ),
                sweetLabel: 'Home',
                sweetTooltip: 'Home',
                iconColors: iconLinearGradiant,
              ),
              SweetNavBarItem(
                  sweetIcon: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(214, 59, 59, 59),
                  ),
                  sweetActive: const Icon(
                    Icons.location_on,
                  ),
                  sweetTooltip: 'Track Order',
                  iconColors: iconLinearGradiant,
                  sweetLabel: 'Business'),
              SweetNavBarItem(
                  sweetIcon: Image.asset(
                    'assets/images/return-of-investment.png',
                    height: 25,
                    color: const Color.fromARGB(214, 59, 59, 59),
                  ),
                  sweetActive: Image.asset(
                    'assets/images/return-of-investment.png',
                    height: 25,
                    color: const Color.fromARGB(255, 72, 3, 80),
                  ),
                  sweetTooltip: 'Rate',
                  iconColors: iconLinearGradiant,
                  sweetLabel: 'S'),
              SweetNavBarItem(
                  sweetIcon: const Icon(
                    Icons.dashboard_outlined,
                    color: Color.fromARGB(214, 59, 59, 59),
                  ),
                  sweetActive: const Icon(
                    Icons.dashboard_outlined,
                  ),
                  sweetTooltip: 'Service',
                  iconColors: iconLinearGradiant,
                  sweetLabel: 'T'),
              SweetNavBarItem(
                  sweetIcon: const Icon(
                    color: Color.fromARGB(214, 59, 59, 59),
                    Icons.person_2_outlined,
                  ),
                  sweetTooltip: 'Profile',
                  iconColors: iconLinearGradiant,
                  sweetActive: const Icon(Icons.person_2_outlined),
                  sweetLabel: 'School'),
            ],
            onTap: (index) {
              if (index != cIndex) {
                setState(() {
                  cIndex = index;
                });
                if (index == 0) {
                  ctrl?.loadUrl(
                      urlRequest: URLRequest(url: Uri.parse(widget.url)));
                } else if (index == 1) {
                  ctrl?.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse(
                              'https://finallink.co/tracking-services/')));
                } else if (index == 2) {
                  ctrl?.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse('https://finallink.co/rates/')));
                } else if (index == 3) {
                  ctrl?.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse('https://finallink.co/services/')));
                } else if (index == 4) {
                  ctrl?.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse('https://finallink.co/dashboard/')));
                }
              }
            },
          ),
          body: error
              ? errorpage()
              : error4
                  ? Stack(
                      children: [
                        Image.asset(
                          'assets/images/broken_link.png',
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const Positioned(
                          bottom: 230,
                          left: 30,
                          child: Text(
                            'Broken Link',
                            style: kTitleTextStyle,
                          ),
                        ),
                        const Positioned(
                          bottom: 170,
                          left: 30,
                          child: Text(
                            'The link you followed may be broken,\nor the page may have been removed.',
                            style: kSubtitleTextStyle,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Positioned(
                          bottom: 60,
                          left: 40,
                          right: 40,
                          child: ReusablePrimaryButton(
                            childText: 'Go Back',
                            buttonColor: Colors.blue[800]!,
                            childTextColor: Colors.white,
                            onPressed: () async {
                              ctrl!.loadUrl(
                                  urlRequest:
                                      URLRequest(url: Uri.parse(widget.url)));
                              setState(() {
                                error4 = false;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: InAppWebView(
                              androidOnGeolocationPermissionsShowPrompt:
                                  (InAppWebViewController controller,
                                      String origin) async {
                                await Permission.location.request();
                                return Future.value(
                                    GeolocationPermissionShowPromptResponse(
                                        origin: origin,
                                        allow: true,
                                        retain: true));
                              },
                              androidOnPermissionRequest:
                                  (InAppWebViewController controller,
                                      String origin,
                                      List<String> resources) async {
                                if (resources.isNotEmpty) {
                                } else {
                                  for (var element in resources) {
                                    if (element.contains("AUDIO_CAPTURE")) {
                                      await Permission.microphone.request();
                                    }
                                    if (element.contains("VIDEO_CAPTURE")) {
                                      await Permission.camera.request();
                                    }
                                  }
                                }
                                return PermissionRequestResponse(
                                    resources: resources,
                                    action:
                                        PermissionRequestResponseAction.GRANT);
                              },
                              key: webViewKey,
                              initialUserScripts: UnmodifiableListView([]),
                              initialUrlRequest:
                                  URLRequest(url: Uri.parse(widget.url)),
                              initialOptions: InAppWebViewGroupOptions(
                                  crossPlatform: InAppWebViewOptions(
                                    disableHorizontalScroll: false,
                                    useShouldOverrideUrlLoading: true,
                                    javaScriptEnabled: true,
                                    cacheEnabled: true,
                                    userAgent:
                                        'Mozilla/5.0 (Linux; Android 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Mobile Safari/537.36',
                                    useOnDownloadStart: true,
                                    mediaPlaybackRequiresUserGesture: false,
                                  ),
                                  android: AndroidInAppWebViewOptions(
                                    useHybridComposition: true,
                                    mixedContentMode: AndroidMixedContentMode
                                        .MIXED_CONTENT_ALWAYS_ALLOW,
                                    // supportMultipleWindows: true,
                                    textZoom: 96,
                                  ),
                                  ios: IOSInAppWebViewOptions(
                                    allowsInlineMediaPlayback: true,
                                  )),
                              onWebViewCreated:
                                  (InAppWebViewController controlle) {
                                ctrl = controlle;
                              },
                              onEnterFullscreen: (ctrl) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft
                                ]);
                              },
                              onExitFullscreen: (ctrl) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitDown,
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                ]);
                              },
                              onProgressChanged: (controller, progress) async {
                                if (progress == 100) {
                                  pullToRefreshController.endRefreshing();
                                }
                              },
                              onLoadHttpError:
                                  (controller, url, statusCode, description) {
                                setState(() {
                                  error4 = true;
                                });
                              },
                              shouldOverrideUrlLoading:
                                  (controller, request) async {
                                var uri = request.request.url;
                                var url = request.request.url.toString();
                                if (url.startsWith(
                                    "https://thefuturestrust.com/")) {
                                  return NavigationActionPolicy.CANCEL;
                                } else if (Platform.isAndroid &&
                                    url.contains("intent")) {
                                  if (url.contains("maps")) {
                                    var mNewURL =
                                        url.replaceAll("intent://", "https://");
                                    if (await canLaunchUrl(
                                        Uri.parse(mNewURL))) {
                                      await launchUrl(Uri.parse(mNewURL));
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  } else {
                                    String id = url.substring(
                                        url.indexOf('id%3D') + 5,
                                        url.indexOf('#Intent'));
                                    await StoreRedirect.redirect(
                                        androidAppId: id);
                                    return NavigationActionPolicy.CANCEL;
                                  }
                                } else if (url.contains("linkedin.com") ||
                                    url.contains("market://") ||
                                    url.contains("whatsapp://") ||
                                    url.contains("truecaller://") ||
                                    url.contains("facebook.com") ||
                                    url.contains("twitter.com") ||
                                    url.contains("www.google.com/maps") ||
                                    url.contains("pinterest.com") ||
                                    url.contains("snapchat.com") ||
                                    url.contains("instagram.com") ||
                                    url.contains("play.google.com") ||
                                    url.contains("mailto:") ||
                                    url.contains("tel:") ||
                                    url.contains("google.it") ||
                                    url.contains("share=telegram") ||
                                    url.contains("messenger.com")) {
                                  try {
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    }
                                    return NavigationActionPolicy.CANCEL;
                                  } catch (e) {
                                    launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                    return NavigationActionPolicy.CANCEL;
                                  }
                                } else if (![
                                  "http",
                                  "https",
                                  "chrome",
                                  "data",
                                  "javascript",
                                  "about"
                                ].contains(uri!.scheme)) {
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                    return NavigationActionPolicy.CANCEL;
                                  }
                                }

                                return NavigationActionPolicy.ALLOW;
                              },
                              onJsConfirm:
                                  (controller, jsConfirmRequest) async {
                                JsConfirmResponseAction.CONFIRM;
                              },
                              onJsAlert:
                                  ((controller, jsAlertRequest) async {}),
                              pullToRefreshController: pullToRefreshController,
                              onLoadStop: (ctr, urli) {
                                doneLoading();
                                pullToRefreshController.endRefreshing();
                              },
                              onDownloadStartRequest: (controller, url) async {
                                if (await Permission.storage.isGranted) {
                                  var appDirectory =Platform.isIOS ?await getApplicationSupportDirectory():
                                      await getExternalStorageDirectory();
                                  var filename =
                                      "doc_${DateTime.now().microsecondsSinceEpoch.toString()}.${url.suggestedFilename!.split('.')[1]}";
                                  if (appDirectory != null) {
                                    await FlutterDownloader.enqueue(
                                        url: url.url.toString(),
                                        savedDir: appDirectory.path,
                                        fileName: filename,
                                        showNotification:
                                            true, // show download progress in status bar (for Android)
                                        openFileFromNotification: true,
                                        saveInPublicStorage: true);
                                  } else {
                                    var d =
                                        await getApplicationDocumentsDirectory();
                                    await FlutterDownloader.enqueue(
                                      url: url.url.toString(),
                                      savedDir: d.path,
                                      fileName: filename,
                                      showNotification:
                                          true, // show download progress in status bar (for Android)
                                      openFileFromNotification: false,
                                    );
                                  }
                                } else {
                                  await Permission.storage.request();
                                }
                              },
                              onPrint: (controller, url) async {
                                var webViewController = controller;
                                if (await Permission.storage.isGranted) {
                                  var widgetsBingind = WidgetsBinding.instance;
                                  if (widgetsBingind.window.viewInsets.bottom >
                                      0.0) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    if (FocusManager.instance.primaryFocus !=
                                        null) {
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                    }
                                    await webViewController.evaluateJavascript(
                                        source:
                                            "document.activeElement.blur();");
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));
                                  }
                                  // }

                                  var a = await controller
                                      .takeScreenshot(
                                          screenshotConfiguration:
                                              ScreenshotConfiguration())
                                      .timeout(
                                        const Duration(milliseconds: 1500),
                                        onTimeout: () => null,
                                      );

                                  if (a != null) {
                                    var appDirectory =
                                        await getExternalStorageDirectory();

                                    if (appDirectory != null) {
                                      final pathOfImage = await File(
                                              '${appDirectory.path}/${DateTime.now().millisecond.toString()}.png')
                                          .create();
                                      final Uint8List bytes =
                                          a.buffer.asUint8List();
                                      await pathOfImage.writeAsBytes(bytes);
                                    } else {
                                      final directory =
                                          await getApplicationDocumentsDirectory();
                                      final pathOfImage = await File(
                                              '${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png')
                                          .create();
                                      final Uint8List bytes =
                                          a.buffer.asUint8List();
                                      await pathOfImage.writeAsBytes(bytes);
                                    }
                                  }
                                } else {
                                  await Permission.storage.request();
                                }
                              },
                              onLoadError: (controller, url, code, message) {
                                pullToRefreshController.endRefreshing();
                                setState(() {
                                  error = true;
                                });
                              },
                              onLoadStart: (ctr, urli) {
                                startLoading();
                                pullToRefreshController.endRefreshing();
                              }),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget errorpage() {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/10_Connection Lost.png'),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Align(
          alignment: FractionalOffset.bottomRight,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: RawMaterialButton(
              onPressed: () async {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult != ConnectivityResult.none) {
                  setState(() {
                    error = false;

                    // I am connected to a mobile network.
                  });
                }
              },
              elevation: 2.0,
              fillColor: Colors.amberAccent,
              padding: const EdgeInsets.all(18.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.refresh,
                color: Colors.blueGrey,
                size: 38.0,
              ),
            ),
          ),
        ));
  }
}

Future load(BuildContext context) async {
  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //           content: SizedBox(
  //             height: 50,
  //             width: MediaQuery.of(context).size.width * 0.90,
  //             child: Row(
  //               children: [
  //                 const CircularProgressIndicator(),
  //                 const SizedBox(
  //                   width: 20,
  //                 ),
  //                 const Text("Loading")
  //               ],
  //             ),
  //           ),
  //         ));
  // Future.delayed(const Duration(seconds: 3), () => Navigator.of(context).pop());
}
