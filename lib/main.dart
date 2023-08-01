import 'dart:async';

import 'package:covicheck/data.dart';
import 'package:covicheck/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new Screen());
}

class Screen extends StatelessWidget {
  static String route = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scr(),
    );
  }
}

class Scr extends StatefulWidget {
  @override
  _ScrState createState() => _ScrState();
}

class _ScrState extends State<Scr> {
  goafter() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Home();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
          ),
          (route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goafter();
    func = fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //  statusBarColor: Color(4294967295),
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Color(4278656301),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "1",
              child: Center(
                child: Image.asset(
                  "assets/images/1.gif",
                ),
              ),
            ),
          ]),
    );
  }
}
