import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = SplashController(context, child);

    controller.startSplashTimer();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Expanded(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation/running_car.json',
                      width: 300,
                      height: 300,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PARKLY",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
