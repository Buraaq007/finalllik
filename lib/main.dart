import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:finallinkapp/animationsplash/animationsplash.dart';
import 'package:finallinkapp/introduction_animation/introduction_animation_screen.dart';
import 'package:finallinkapp/widget/nativehelper.dart';
import 'package:finallinkapp/widget/webviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send =
      IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(ignoreSsl: true);
  await FlutterDownloader.registerCallback(downloadCallback);
  // } catch (e) {}
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var a = prefs.getBool('into') ?? false;
  runApp(MyApp(
    home: a,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.home});
  final bool home;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Final Link",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, textTheme: TextTheme()),
      home: MyHomePage(
        keys: home,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final bool keys;
  const MyHomePage({super.key, required this.keys});

  @override
  Widget build(BuildContext context) {
    return keys
        ? FlutterSplashScreen.scale(
            duration: const Duration(milliseconds: 4000),
            animationDuration: const Duration(milliseconds: 3000),
            backgroundColor: HexColor('#FFFFFF'),
            defaultNextScreen: const WebViewMini(
              url: "https://finallink.co/dashboard/",
            ),
            childWidget: SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/images/i.jpeg'),
            ))
        : const IntroductionAnimationScreen();
  }
}
