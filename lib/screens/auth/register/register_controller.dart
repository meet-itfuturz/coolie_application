import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repositories/authentication_repo.dart';
import '../../../routes/route_name.dart';
import '../../../services/app_toasting.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final buckleController = TextEditingController();
  final addressController = TextEditingController();

  var selectedGender = "Male".obs;
  var selectedDevice = "SmartPhone".obs;

  final AuthenticationRepo authenticationRepo = Get.find();

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty) {
      AppToasting.showError("Please fill all required fields");
      return;
    }

    isLoading.value = true;
    final data = {
      "name": nameController.text.trim(),
      "mobileNo": mobileController.text.trim(),
      "age": int.tryParse(ageController.text.trim()) ?? 0,
      "deviceType": selectedDevice.value,
      "emailId": emailController.text.trim(),
      "gender": selectedGender.value,
      "buckleNumber": buckleController.text.trim(),
      "address": addressController.text.trim(),
      "image": "default.png"
    };

    debugPrint("DATAAA $data");
    final response = await authenticationRepo.registerCoolie(data);
    if (response != null) {
      AppToasting.showSuccess("User registered successfully!");
      Get.toNamed(RouteName.home);
    }
    isLoading.value = false;
  }
}

