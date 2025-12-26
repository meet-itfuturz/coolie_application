import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../repositories/authentication_repo.dart';
import '../../../services/app_storage.dart';
import '../../../services/app_toasting.dart';

class CheckInController extends GetxController {
  final coolieImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final isLoading = RxBool(false);
  final AuthenticationRepo authenticationRepo = Get.find();

  TextEditingController mobileNumberController = TextEditingController();
  final isConfirmEnabled = false.obs;
  final isEnable = false.obs;
  // final isCheckedIn = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // final args = Get.arguments;
    // log("===============arguments: $args==============");
    // if (args != null) {
    //   isCheckedIn.value = args;
    // } else {
    //   errorToast('Error', 'Checked in is not coming');
    //   Get.back();
    // }
    _loadMobileNumber();
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    super.onClose();
  }

  void resetState() {
    coolieImage.value = null;
    mobileNumberController.clear();
    isLoading.value = false;
    isEnable.value = false;
    _loadMobileNumber();
  }

  void _loadMobileNumber() {
    try {
      final userMobile = (AppStorage.read("userMobile"));
      debugPrint("User details: $userMobile");
      if (userMobile != null) {
        debugPrint("User mobile number: ${userMobile}");
        mobileNumberController.text = userMobile;
      } else {
        debugPrint("User isEnable false");
        isEnable.value = true;
      }
    } catch (e) {
      debugPrint("Error loading mobile number: $e");
      mobileNumberController.text = '';
    }
  }

  Future<void> pickCoolieImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 800, imageQuality: 90);
      if (image != null) {
        coolieImage(File(image.path));
        update();
      }
    } catch (e) {
      errorToast('Failed to pick image: $e');
    }
  }

  bool get isButtonEnabled {
    return coolieImage.value != null && mobileNumberController.text.length == 10 && !isLoading.value;
  }

  Future<void> validateFace(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (coolieImage.value == null) {
      errorToast('Please capture your photo first');
      return;
    }

    isLoading(true);
    update();

    try {
      // Create FormData and add both mobileNo and image
      final formData = dio.FormData.fromMap({"mobileNo": mobileNumberController.text.trim()});

      // Add image as file
      if (coolieImage.value != null) {
        formData.files.add(
          MapEntry('file', await dio.MultipartFile.fromFile(coolieImage.value!.path, filename: 'coolie_${DateTime.now().millisecondsSinceEpoch}.jpg')),
        );
      }

      debugPrint("Sending Mobile: ${formData.fields}");
      debugPrint("Final FormData fields: ${formData.fields}");
      debugPrint("FormData files: ${formData.files.length}");

      // Send FormData instead of JSON
      var result = await authenticationRepo.faceDetection(formData);
      debugPrint("API Response: $result");

      if (result != null && result['success'] == true) {
        coolieImage.value = null;
        // Navigate back first, then show success message
        Get.back(result: true);
        update();
        
        // Show success message after navigation is complete
        Future.delayed(const Duration(milliseconds: 500), () {
          successToast(result['message'] ?? "Face login successful!");
        });
      } else if (result != null && result['success'] == false) {
        // Show error message - ensure it's called on UI thread
        final errorMessage = result['message'] ?? "Face detection failed";
        
        // Use WidgetsBinding to ensure we're on UI thread
        WidgetsBinding.instance.addPostFrameCallback((_) {
          errorToast(errorMessage);
        });
        
        // Also log for debugging
        debugPrint("Face detection failed: $errorMessage");
      } else {
        // Handle null result
        WidgetsBinding.instance.addPostFrameCallback((_) {
          errorToast("Face detection failed: No response from server");
        });
      }
    } catch (e) {
      debugPrint("Error in validateFace: $e");
      errorToast('Failed to process request: $e');
    } finally {
      isLoading(false);
      update();
    }
  }
}
