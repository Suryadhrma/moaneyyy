import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        _visible = true;
      });
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _visible = false;
      });
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: _visible ? 1 : 0),
          duration: Duration(seconds: 2),
          builder: (context, double opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Image.asset('assets/logo.png'),
            );
          },
        ),
      ),
    );
  }
}
