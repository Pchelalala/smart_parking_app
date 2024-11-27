import 'package:flutter/material.dart';

class SplashController {
  final BuildContext context;
  final Widget? child;

  SplashController(this.context, this.child);

  void startSplashTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => child!),
        (route) => false,
      );
    });
  }
}
