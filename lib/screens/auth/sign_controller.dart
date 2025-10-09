import '/services/notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:coolie_application/routes/route_name.dart';
import '../../services/helper.dart';
import 'auth_service.dart';

class SignController extends GetxController {
  final isLoading = false.obs;
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String deviceId = '';
  String fcmToken = '';
  late final AuthService authService;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    mobileController.text = '';
    _getDeviceId();
    _getFcmToken();
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
    fcmToken = (await notificationService.getToken())!;
    debugPrint("FCM Token: $fcmToken");
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await authService.signIn(mobileNo: mobileController.text, deviceId: deviceId, fcm: fcmToken);

      if (response != null) {
        debugPrint("SignIn Response: ${response}");
        Get.toNamed(RouteName.otpVerification, arguments: {"mobileNo": mobileController.text});
      } else {
        Get.snackbar('Error', 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      debugPrint("SignIn Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}
