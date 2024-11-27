import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smart_parking_app/features/notifications/firebase_notification_api.dart';
import 'package:smart_parking_app/features/payment/consts.dart';
import 'package:smart_parking_app/screens/leave_review_screen.dart';
import 'package:smart_parking_app/screens/parking_spots_screen.dart';
import 'package:smart_parking_app/screens/parkings_screen.dart';
import 'package:smart_parking_app/screens/user_reviews_screen.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDKi-4E_4_TRHFrhmPIbk431sQGOIv2LAQ",
            appId: "1:737151851108:web:4724c8fd9dbb2316fedd71",
            messagingSenderId: "737151851108",
            projectId: "smart-parking-app-b7155"));
  } else {
    await Firebase.initializeApp();
    await FirebaseApi().initNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking App',
      navigatorKey: navigatorKey,
      home: const SplashScreen(
        child: LoginScreen(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/parkings': (context) => const ParkingsScreen(),
        '/parkingSpots': (context) => const ParkingSpotsScreen(),
        '/userReview': (context) => const UserReviewsScreen(),
        '/leaveReview': (context) => const LeaveReviewScreen(),
      },
    );
  }
}
