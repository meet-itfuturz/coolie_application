import 'dart:async';
import 'dart:convert';
import 'package:coolie_application/routes/route_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../services/app_storage.dart';
import '../../../services/app_toasting.dart';
import '../../../services/helper.dart';
import '../auth_service.dart';

class OtpVerifyController extends GetxController {
  final mobile = ''.obs;
  String deviceId = '';
  String fcmToken = '';
  final verificationCodeController = TextEditingController();
  late final AuthService authService;
  final isLoading = false.obs;
  final isResendEnabled = true.obs;
  final countdown = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _getDeviceId();
    _getFcmToken();
    final args = Get.arguments;
    if (args != null && args["mobileNo"] != null) {
      mobile.value = args["mobileNo"];
    } else {
      Get.snackbar('Error', 'Mobile number not provided');
      Get.back();
    }
    _startTimer();
  }

  void _initializeServices() {
    try {
      authService = Get.find<AuthService>();
    } catch (e) {
      authService = Get.put(AuthService());
    }
  }

  Future<void> _getDeviceId() async {
    deviceId = await helper.getDeviceUniqueId();
    debugPrint("Device ID: $deviceId");
  }

  Future<void> _getFcmToken() async {
    // Replace with actual FCM token retrieval logic
    // fcmToken = await helper.getFcmToken(); // Assume helper has this method
    debugPrint("FCM Token: $fcmToken");
  }

  void _startTimer() {
    isResendEnabled.value = false;
    countdown.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    if (verificationCodeController.text.trim().isEmpty) {
      AppToasting.showWarning("Please enter OTP");
      return;
    }

    if (verificationCodeController.text.trim().length != 4) {
      AppToasting.showWarning("Please enter a valid 4-digit OTP");
      return;
    }

    isLoading.value = true;
    try {
      final request = {"mobileNo": mobile.value, "otpCode": verificationCodeController.text.trim(), "fcm": fcmToken, "deviceId": deviceId};

      debugPrint("OTP Verify Request: $request");

      final userModel = await authService.verifyOtp(request);
      final userMobile = userModel?.user.mobileNo ?? "";
      if (userModel != null) {
        await AppStorage.write('token', userModel.token);
        await AppStorage.write('userMobile', userMobile);
        await AppStorage.write('user', json.encode(userModel.toJson()));
        AppToasting.showSuccess("OTP Verified Successfully");
        Get.offAllNamed(RouteName.home);
      } else {
        AppToasting.showError("Invalid OTP. Please try again.");
      }
    } catch (e) {
      AppToasting.showError("An error occurred: $e");
      debugPrint("Verify OTP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;
    try {
      final request = {"mobileNo": mobile.value};
      await authService.reSendOtp(request);
      AppToasting.showSuccess("OTP resent successfully");
      _startTimer();
    } catch (e) {
      AppToasting.showError("Failed to resend OTP: $e");
      debugPrint("Resend OTP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    verificationCodeController.dispose();
    super.onClose();
  }
}
