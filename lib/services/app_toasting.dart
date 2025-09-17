import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToasting {
  // Success toast
  static void showSuccess(
      String message, {
        String title = 'Success',
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      message,
      title: title,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  // Error toast
  static void showError(
      String message, {
        String title = 'Error',
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      message,
      title: title,
      backgroundColor: Colors.red,
      icon: Icons.error,
      duration: duration,
    );
  }

  // Warning toast
  static void showWarning(
      String message, {
        String title = 'Warning',
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      message,
      title: title,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      duration: duration,
    );
  }

  // Info toast
  static void showInfo(
      String message, {
        String title = 'Info',
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      message,
      title: title,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      duration: duration,
    );
  }

  // Main toast method
  static void _showToast(
      String message, {
        required String title,
        required Color backgroundColor,
        required IconData icon,
        Duration duration = const Duration(seconds: 3),
      }) {
    closeAllToasts();
    Get.snackbar(
      title,
      message,
      duration: duration,
      backgroundColor: backgroundColor.withOpacity(0.9),
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      barBlur: 5,
    );
  }

  // Close all toasts
  static void closeAllToasts() {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
  }
}