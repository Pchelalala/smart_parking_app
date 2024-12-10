import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NowPaymentsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api-sandbox.nowpayments.io/v1',
      headers: {
        'x-api-key': '9CRRCN1-VMHM1XE-MAG8W3G-WXHSF5M',
      },
    ),
  );

  Future<String?> createPayment(
      double amount, String currency, String crypto) async {
    try {
      final response = await _dio.post('/invoice', data: {
        "price_amount": amount,
        "price_currency": currency,
        "pay_currency": crypto,
        "order_id": "test_order_123",
        "order_description": "Test payment integration",
        "ipn_callback_url":
            "https://webhook.site/c1f3fb2a-4cbd-4912-871e-6203ed6104b3",
      });

      if (response.statusCode == 200) {
        return response.data['invoice_url'];
      } else {
        if (kDebugMode) {
          print('Error creating payment: ${response.data}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }
}
