import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReviewController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getReviewsStream() {
    return _firestore
        .collection('reviews')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  String formatDate(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return DateFormat.yMMMd().add_jm().format(date);
  }
}
