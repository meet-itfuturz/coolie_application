import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coolie_application/routes/route_name.dart';

import '../../repositories/authentication_repo.dart';
import '../../services/app_toasting.dart';
import '../../services/helper.dart';

class SignController extends GetxController {
  var userType = 'Traveller'.obs;
  final isLoading = false.obs;
  final mobileController =TextEditingController();
  final formKey = GlobalKey<FormState>();
  String deviceId = '';
  final AuthenticationRepo authenticationRepo = Get.find();

  @override
  void onInit() {
    super.onInit();
    mobileController.text = '';
    _getDeviceId();
  }

  void onChangeView(String value) {
    userType.value = value;
  }

  Future<void> _getDeviceId() async {
    deviceId = await helper.getDeviceUniqueId();
    debugPrint("Device ID: $deviceId");
  }


  Future<void> signIn() async {
    isLoading.value = true;

    final response = await authenticationRepo.signIn(
      mobileNo: mobileController.text,
      deviceId: "1234",
      fcm: "",
    );

    isLoading.value = false;
    debugPrint("RESPONSE $response");
    if (response != null) {
      debugPrint("SignIn Response: ${response}"); // debug
      Get.toNamed(RouteName.otpVerification, arguments: {
        "mobileNo": mobileController.text,
      });
    }
    // AppToasting.showInfo("Something went wrong: ${response?.message ?? 'No response'}");
  }


}
