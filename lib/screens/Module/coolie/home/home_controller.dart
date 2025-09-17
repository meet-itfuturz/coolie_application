import 'package:coolie_application/models/coolie_user_profile.dart';
import 'package:coolie_application/routes/route_name.dart';
import 'package:coolie_application/services/app_storage.dart';
import 'package:coolie_application/services/app_toasting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../models/get_passenger_coolie_model.dart';
import '../../../../repositories/authentication_repo.dart';
import '../../../../services/customs/otp_verification.dart';
import '../../../../utils/app_constants.dart';

class HomeController extends GetxController {
  final AuthenticationRepo _authRepo = AuthenticationRepo();
  final checkStatuss=''.obs;

  Rx<GetPassengerCoolieModel> passengerDetails = GetPassengerCoolieModel().obs;
  final verificationCodeController = TextEditingController();

  /// Profile data observable
  var userProfile = Rxn<CoolieUserProfile>();

  /// Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    getPassengerData();
    // checkStatus();
  }

  /// 🔹 API call to fetch profile
  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    debugPrint("Fetching user profile...");

    final profile = await _authRepo.getUserProfile();

    if (profile != null) {
      userProfile.value = profile;
      debugPrint("✅ Fetched User Name: ${profile.name}");
      debugPrint("✅ Fetched User Email: ${profile.emailId}");
      debugPrint("✅ Fetched User Mobile: ${profile.mobileNo}");
      debugPrint("✅ Fetched User ID: ${profile.id}");
    } else {
      debugPrint("❌ Profile is null - check API response structure");
      final result = await _authRepo.getUserProfile();
      debugPrint("Raw API result: $result");
    }

    isLoading.value = false;
    update();
  }

  Future<void> getPassengerData() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.getPassenger();
      debugPrint("MODEL ${response}");
      passengerDetails.value = GetPassengerCoolieModel.fromJson(response);
      debugPrint("userProfile.value ${passengerDetails.value.toJson()}");
    } catch (e) {
      debugPrint("Failed to load Passenger: ${e.toString()}");
      // AppToasting.showError('Failed to load Passenger: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bookPassenger(bookingId) async {
    try {
      isLoading.value = true;
      final response = await _authRepo.bookPassenger(bookingId);
      debugPrint("Booking ${response}");
      if (response != null) {
        otpDialog();
      }
    } catch (e) {
      AppToasting.showError('Failed to load bookPassenger: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bookingOPTVerify(String? bookingId) async {
    if (bookingId == null) {
      AppToasting.showError("Booking ID not found!");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authRepo.verifyBookingOTP(
        bookingId,
        verificationCodeController.text.trim(),
      );

      debugPrint("OTP Verify Response: $response");

      if (response != null) {
        // await getPassengerData();
        await AppStorage.write('status', response['booking']['status']);
        debugPrint("statusDATA ${response['booking']['status']}");
        await checkStatus();
        await getPassengerData();
        Get.back();
        AppToasting.showSuccess("OTP Verified Successfully!");
      }
    } catch (e) {
      AppToasting.showError('Failed to verify OTP: ${e.toString()}');
    } finally {
      isLoading.value = false;
      update();
    }
  }



  void otpDialog(){
    Get.dialog(
      barrierDismissible: false,
        AlertDialog(
          title: Text("Enter OTP", style: GoogleFonts.poppins(
            fontSize: 15,
          ),),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinCodeTextField(
              highlight: true,
              maxLength: 4,
              pinBoxWidth: 45,
              pinBoxHeight: 45,
              pinBoxRadius: 6,
              pinBoxBorderWidth: 0.75,
              wrapAlignment: WrapAlignment.center,
              highlightPinBoxColor: Colors.white,
              highlightColor: Constants.instance.primary,
              defaultBorderColor: Colors.grey.shade500,
              keyboardType: TextInputType.number,
              pinTextStyle: TextStyle(fontSize: 14),
              pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
              pinBoxColor: Colors.transparent,
              errorBorderColor: Colors.redAccent,
              hasTextBorderColor: Colors.black,
              controller:verificationCodeController,
            ),
            SizedBox(height: 20,),
            MaterialButton(onPressed: () async{
             await bookingOPTVerify(passengerDetails.value.booking?.id);
              Navigator.pop(Get.context!);
              },
              height: 40,
              minWidth: 120,
              color: Constants.instance.primary,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Constants.instance.primary)
              ),
              child: Text("Verify", style: GoogleFonts.poppins(color: Constants.instance.white),),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> completeService(String? bookingId) async {
    if (bookingId == null) {
      AppToasting.showError("Booking ID not found!");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authRepo.completeService(
        bookingId,
      );
      debugPrint("OTP Verify Response: $response");
      if (response != null) {
        AppToasting.showSuccess("Service Completed!");
        await getPassengerData();
        update();
      }
    } catch (e) {
      AppToasting.showError('Failed to verify OTP: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.logOut();
      debugPrint("Booking ${response}");
      if (response != null) {
        Get.back();
      }
    } catch (e) {
      AppToasting.showError('Failed to load LogOut: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkStatus() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.checkStatus();
      debugPrint("Booking Status Response: $response");

      if (response != null) {
        debugPrint("Booking Status Response not null: $response");
        checkStatuss.value = response;
        debugPrint("Current Status => ${checkStatuss.value}");
      }
    } catch (e) {
      AppToasting.showError('Failed to load checkOut: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }



  void showLogoutDialog() {
    Get.defaultDialog(
      radius: 16.0,
      title: "Logout",
      titlePadding: const EdgeInsets.all(25.0),
      contentPadding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await logOut();
            Get.offAllNamed(RouteName.signIn);
            // await clearStorage();
            // Get.offAllNamed(AppRouteNames.login);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }


  String formatBookingTime(String? isoTime) {
    if (isoTime == null) return "N/A";
    try {
      final dt = DateTime.parse(isoTime).toLocal();
      return DateFormat("hh:mm a, MMM dd").format(dt);
    } catch (e) {
      return "N/A";
    }
  }




  Future<void> logout() async {
    await AppStorage.clearAll();
    Get.offAllNamed(RouteName.signIn);
  }
}