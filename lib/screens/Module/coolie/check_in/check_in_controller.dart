

import 'dart:io';

import 'package:coolie_application/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

import '../../../../repositories/authentication_repo.dart';
import '../../../../services/app_toasting.dart';

class CheckInController extends GetxController{
  final coolieImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final isLoading = RxBool(false);
  final AuthenticationRepo authenticationRepo = Get.find();


  final mobileKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  final isConfirmEnabled = false.obs;

  Future<void> pickCoolieImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );
      if (image != null) {
        coolieImage(File(image.path));
        // await validateFace();
      }
    } catch (e) {
      AppToasting.showError('Failed to pick image: $e');
    }
  }

  Future<void> validateFace() async {
    if (!mobileKey.currentState!.validate()) {
      return;
    }
    isLoading(true);
    try {
      // FormData fields ko properly add karna hoga

      Map<String,dynamic>json={
        "mobileNo":mobileNumberController.text.trim(),
      };
      final formData = dio.FormData.fromMap(json);
      debugPrint("Sending Mobile: ${formData.fields}");

      if (coolieImage.value != null) {
        formData.files.add(
          MapEntry(
            'image',
            await dio.MultipartFile.fromFile(
              coolieImage.value!.path,
              filename: 'coolie_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }
      debugPrint("Final FormData fields: ${formData.fields}");

      var result = await authenticationRepo.faceDetection(json);
      debugPrint("API Response: $result");
      if (result != null) {
        Get.toNamed(RouteName.home);
        update();
      }
    } finally {
      isLoading(false);
    }
  }



}