import 'package:flutter/material.dart';
import '../features/gps_navigation/navigation_helper.dart';

class ParkingsController {
  void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  void navigateToParkingSpotsScreen(BuildContext context, String address) {
    Navigator.pushNamed(context, '/parkingSpots');
  }

  void navigateToUserReviewsScreen(BuildContext context) {
    Navigator.pushNamed(context, '/userReview');
  }

  void navigateToSpot(
      BuildContext context, double? latitude, double? longitude) {
    if (latitude != null && longitude != null) {
      try {
        NavigationHelper.openMap(latitude, longitude);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open map'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location data is not available'),
        ),
      );
    }
  }
}
