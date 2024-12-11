import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  static Future<void> openMap(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';
    final appleMapsUrl =
        'https://maps.apple.com/?daddr=$latitude,$longitude&dirflg=d';

    final uri = Uri.parse(Platform.isIOS ? appleMapsUrl : googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Error opening map';
    }
  }
}
