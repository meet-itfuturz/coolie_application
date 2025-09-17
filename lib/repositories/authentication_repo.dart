import 'dart:convert';

import 'package:flutter/material.dart';

import '../api constants/api_manager.dart';
import '../api constants/network_constants.dart';
import '../models/coolie_user_profile.dart';
import '../models/sign_in_response_model.dart';
import '../models/user_model.dart';
import '../services/app_toasting.dart';

class AuthenticationRepo {
  Future<AuthenticationRepo> init() async => this;

  // AuthenticationRepo
  Future<SignInResponseModel?> signIn({
    required String mobileNo,
    required String deviceId,
    required String fcm,
  }) async {
    try {
      final result = await apiManager.post(
        NetworkConstants.signIn,
        data: {
          "mobileNo": mobileNo,
          "deviceId": deviceId,
          "fcm": fcm,
        },
      );

      debugPrint("SignIn Raw Response: ${result.data}");

      // Yaha pura result.data pass kare
      if (result.data is Map<String, dynamic>) {
        return SignInResponseModel.fromJson(result.data);
      } else {
        debugPrint("Invalid response format: ${result.data}");
        return null;
      }
    } catch (e, stack) {
      debugPrint("SignIn API Error: $e\n$stack");
      return null;
    }
  }








  Future<bool> sendOtp(Map<String, dynamic> request) async {
    try {
      final result = await apiManager.post(
        NetworkConstants.sendOtp,
        data: request,
      );

      // Debugging
      debugPrint("OTP Raw Response: ${result.data}");

      // Agar API data ek Map hai (proper JSON)
      if (result.data is Map<String, dynamic>) {
        debugPrint("OTP Response JSON: ${result.data}");
        return true;
      }

      return true;
    } catch (e) {
      debugPrint("ERROR in sendNotification: $e");
      return false;
    }
  }



  Future<UserModel?> verifyOtp(Map<String, dynamic> request) async {
    try {
      final result = await apiManager.post(
        NetworkConstants.otpVerification,
        data: request,
      );
      final responseData = result.data is String
          ? json.decode(result.data)
          : result.data;

      debugPrint("OTP Verify Response: $responseData");

      final userModel = UserModel.fromJson({
        "user": responseData['user'],
        "token": responseData['token'],
      });
      return userModel;
    } catch (e) {
      debugPrint("ERROR in verifyOtp: $e");
      AppToasting.showError("Network error occurred");
      return null;
    }
  }


  Future<CoolieUserProfile?> getUserProfile() async {
    try {
      final result = await apiManager.post(
        NetworkConstants.getCoolieProfile,
      );

      debugPrint("User Profile Raw Response: ${result.data}");

      if (result.data is Map<String, dynamic>) {
        final responseData = result.data as Map<String, dynamic>;
        Map<String, dynamic> userData;

        if (responseData['data'] != null && responseData['data']['user'] != null) {
          userData = responseData['data']['user'];
          debugPrint("Using nested data->user structure");
        } else if (responseData['user'] != null) {
          userData = responseData['user'];
          debugPrint("Using direct user structure");
        } else {
          debugPrint("User data not found in any expected structure: ${result.data}");
          return null;
        }

        debugPrint("User data to parse: $userData");
        return CoolieUserProfile.fromJson(userData);

      } else {
        debugPrint("Invalid response format for user profile: ${result.data}");
        return null;
      }
    } catch (e, stack) {
      debugPrint("Get User Profile API Error===: $e\n$stack");
      AppToasting.showError("Failed to fetch user profile");
      return null;
    }
  }

  Future<Map<String, dynamic>?> faceDetection(data) async {
    try {
      final result =
      await apiManager.post(NetworkConstants.faceDetect, data: data);
      if (result.status == 200) {
        if (result.data != null) {
          return result.data;
        } else {
          AppToasting.showWarning(result.message);
          return null;
        }
      } else {
        AppToasting.showWarning(result.message);
        return null;
      }
    } catch (err) {
      AppToasting.showWarning(err.toString());
      return null;
    }
  }

  Future<dynamic> getPassenger() async {
    try {
      final response = await apiManager.post(NetworkConstants.getNextBooking, data: {});

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch profile');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching GetPassenger: ${err.toString()}');
      return null;
    }
  }
  Future<dynamic> bookPassenger(bookingId) async {
    try {
      final response = await apiManager.post(NetworkConstants.bookingAction, data: {
        "bookingId":bookingId,
        "action": "accept"
      });

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch bookings');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching BookPassenger: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> verifyBookingOTP(bookingId,otp) async {
    try {
      final response = await apiManager.post(NetworkConstants.startService, data: {
        "bookingId":bookingId,
        "otp": otp
      });

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch OTP');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching OTP: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> completeService(bookingId) async {
    try {
      final response = await apiManager.post(NetworkConstants.completeService, data: {
        "bookingId":bookingId,
      });
      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch OTP');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching Complete: ${err.toString()}');
      return null;
    }
  }
  Future<dynamic> logOut() async {
    try {
      final response = await apiManager.post(NetworkConstants.logout, data: {});
      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch OTP');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching LogOut: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> checkStatus() async {
    try {
      final response = await apiManager.post(NetworkConstants.currentBookingStatus, data: {});
      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch OTP');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching CheckStatus: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> getHistory() async {
    try {
      final response = await apiManager.post(NetworkConstants.allcompletedBookings, data: {});

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch profile');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching History: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> registerCoolie(data) async {
    try {
      final response = await apiManager.post(NetworkConstants.registerCollie, data: data);

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch profile');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching History: ${err.toString()}');
      return null;
    }
  }



}
