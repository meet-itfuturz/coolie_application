import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api constants/api_manager.dart';
import '../../api constants/network_constants.dart';
import '../../models/sign_in_response_model.dart';
import '../../models/user_model.dart';
import '../../routes/route_name.dart';
import '../../services/app_storage.dart';
import '../../services/app_toasting.dart';

class AuthService extends GetxService {
  Future<SignInResponseModel?> signIn({required String mobileNo, required String deviceId, required String fcm}) async {
    try {
      final result = await apiManager.post(NetworkConstants.signIn, data: {"mobileNo": mobileNo, "deviceId": deviceId, "fcm": fcm});

      debugPrint("SignIn Raw Response: ${result.data}");

      if (result.data is Map<String, dynamic>) {
        return SignInResponseModel.fromJson(result.data);
      } else {
        AppToasting.showError(result.message);
        return null;
      }
    } catch (e, stack) {
      debugPrint("SignIn API Error: $e\n$stack");
      AppToasting.showError("Failed to send OTP: $e");
      return null;
    }
  }

  Future<UserModel?> verifyOtp(Map<String, dynamic> request) async {
    try {
      final result = await apiManager.post(NetworkConstants.otpVerification, data: request);
      final responseData = result.data is String ? json.decode(result.data) : result.data;

      debugPrint("OTP Verify Response: $responseData");

      if (responseData['user'] == null || responseData['token'] == null) {
        AppToasting.showError(result.message);
        return null;
      }

      final userModel = UserModel.fromJson({"user": responseData['user'], "token": responseData['token']});
      return userModel;
    } catch (e) {
      debugPrint("ERROR in verifyOtp: $e");
      AppToasting.showError("Network error occurred");
      return null;
    }
  }

  Future<void> reSendOtp(dynamic request) async {
    try {
      final response = await apiManager.post(NetworkConstants.otpVerification, data: request);

      if (response.data == null) {
        AppToasting.showError(response.message);
        return;
      }

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return;
      }

      final verifyData = response.data is String ? json.decode(response.data) : response.data;

      if (verifyData["token"] == null || verifyData["user"] == null) {
        AppToasting.showError("Authentication token or user data not received");
        return;
      }

      await AppStorage.write("token", verifyData["token"]);
      await AppStorage.write("passengerID", verifyData["user"]["_id"]);
      await AppStorage.write("user", json.encode(verifyData["user"]));
      Get.toNamed(RouteName.home);
    } catch (err) {
      log("Resend OTP error: $err");
      AppToasting.showError("Failed to resend OTP: $err");
    }
  }
}
