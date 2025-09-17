import 'package:coolie_application/models/get_passenger_coolie_model.dart';
import 'package:coolie_application/services/app_toasting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../repositories/authentication_repo.dart';

class TravelHomeController extends GetxController {
  late Razorpay _razorpay;
  final isLoading=false.obs;


  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // getPassengerData();
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_huTmioKmO2Z4SA', // 👉 yaha apna Razorpay key daalna
      'amount': (amount * 100).toInt(), // paise me hota hai (INR ₹100 = 10000)
      'name': 'Coolie Booking',
      'description': 'Payment for Coolie Service',
      'prefill': {
        'contact': '9876543210',
        'email': 'testuser@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    AppToasting.showSuccess("Payment Successful Payment ID: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppToasting.showError("Payment Failed response.message ?? Unknown Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", response.walletName ?? "");
  }




  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
