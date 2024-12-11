import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NowPaymentsService {
  final Dio _dio;

  NowPaymentsService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api-sandbox.nowpayments.io/v1',
            headers: {
              'x-api-key': '9CRRCN1-VMHM1XE-MAG8W3G-WXHSF5M',
            },
          ),
        );

  /// Fetches the list of available cryptocurrencies for payments.
  Future<List<String>> getAvailableCurrencies() async {
    try {
      final response = await _dio.get('/currencies', queryParameters: {
        "fixed_rate": true,
      });

      if (response.statusCode == 200 && response.data != null) {
        final currencies = List<String>.from(response.data['currencies'] ?? []);
        return currencies;
      } else {
        throw Exception(
            "Failed to fetch currencies. Status: ${response.statusCode}, "
            "Message: ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while fetching currencies: $e');
      }
      throw Exception("Fetching currencies failed: $e");
    }
  }

  /// Creates a payment and returns the invoice URL.
  Future<String> createPayment({
    required double amount,
    required String currency,
    required String crypto,
    String orderId = "test_order_123",
    String orderDescription = "Test payment integration",
    String callbackUrl =
        "https://webhook.site/c1f3fb2a-4cbd-4912-871e-6203ed6104b3",
  }) async {
    try {
      final response = await _dio.post('/invoice', data: {
        "price_amount": amount,
        "price_currency": currency,
        "pay_currency": crypto,
        "order_id": orderId,
        "order_description": orderDescription,
        "ipn_callback_url": callbackUrl,
      });

      if (response.statusCode == 200 && response.data != null) {
        final invoiceUrl = response.data['invoice_url'];
        if (invoiceUrl != null) {
          return invoiceUrl;
        } else {
          throw Exception("Invoice URL not found in response.");
        }
      } else {
        throw Exception(
            "Failed to create payment. Status: ${response.statusCode}, "
            "Message: ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while creating payment: $e');
      }
      throw Exception("Payment creation failed: $e");
    }
  }
}
