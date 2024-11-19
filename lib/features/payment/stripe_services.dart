import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smart_parking_app/features/payment/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  /// Initiates the payment process
  Future<bool> makePayment() async {
    try {
      // Create Payment Intent
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "usd");
      if (paymentIntentClientSecret == null) {
        if (kDebugMode) {
          print("Failed to create Payment Intent.");
        }
        return false;
      }

      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Liudmyla Pcheliakova",
          style: ThemeMode.system,
        ),
      );

      // Present the Payment Sheet and process payment
      bool isPaymentSuccessful = await _processPayment();
      if (!isPaymentSuccessful) {
        if (kDebugMode) {
          print("Payment failed or canceled.");
        }
        return false;
      }

      if (kDebugMode) {
        print("Payment completed successfully.");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error during payment: $e");
      }
      return false;
    }
  }

  /// Creates a Payment Intent on Stripe
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final dio = Dio();
      final data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (kDebugMode) {
          print("Payment Intent created successfully: ${response.data}");
        }
        return response.data["client_secret"];
      }

      if (kDebugMode) {
        print("Failed to create Payment Intent. Response: ${response.data}");
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating Payment Intent: $e");
      }
      return null;
    }
  }

  /// Presents the Payment Sheet and confirms the payment
  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      if (kDebugMode) {
        print("Payment presented successfully.");
      }
      return true;
    } on StripeException catch (e) {
      if (kDebugMode) {
        print("StripeException occurred: $e");
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected error during payment: $e");
      }
      return false;
    }
  }

  /// Converts the amount to cents (used by Stripe)
  String _calculateAmount(int amount) {
    return (amount * 100).toString(); // Convert dollars to cents
  }
}
