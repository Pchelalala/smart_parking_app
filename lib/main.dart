import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smart_parking_app/API/firebase_api.dart';
import 'package:smart_parking_app/features/payment/consts.dart';
import 'package:smart_parking_app/screens/leave_review_screen.dart';
import 'package:smart_parking_app/screens/parking_spots_screen.dart';
import 'package:smart_parking_app/screens/parkings_screen.dart';
import 'package:smart_parking_app/screens/user_reviews_screen.dart';

import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/home.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/sign_up_page.dart';

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
        child: LoginPage(),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/parkings': (context) => const ParkingsScreen(),
        '/parkingSpots': (context) => const ParkingSpotsScreen(),
        '/userReview': (context) => const UserReviewsScreen(),
        '/leaveReview': (context) => const LeaveReviewScreen(),
      },
    );
  }
}
