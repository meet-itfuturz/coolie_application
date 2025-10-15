import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppToasting {
  static void showSuccess(String message, {String title = 'Success', Duration duration = const Duration(seconds: 3)}) {
    _showGetSnackbar(
      message: message,
      title: title,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static void showError(String message, {String title = 'Error', Duration duration = const Duration(seconds: 3)}) {
    _showGetSnackbar(
      message: message,
      title: title,
      backgroundColor: Colors.red,
      icon: Icons.error,
      duration: duration,
    );
  }

  static void showWarning(String message, {String title = 'Warning', Duration duration = const Duration(seconds: 3)}) {
    _showGetSnackbar(
      message: message,
      title: title,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      duration: duration,
    );
  }

  static void showInfo(String message, {String title = 'Info', Duration duration = const Duration(seconds: 3)}) {
    _showGetSnackbar(
      message: message,
      title: title,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      duration: duration,
    );
  }

  static void _showGetSnackbar({
    required String message,
    required String title,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    try {
      log("Showing Get.snackbar: $title - $message");

      // Ensure we're on the main UI thread
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Close any existing snackbars first
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }

        // Add a small delay to ensure proper cleanup
        Future.delayed(const Duration(milliseconds: 200), () {
          try {
            Get.snackbar(
              title,
              message,
              duration: duration,
              backgroundColor: backgroundColor.withOpacity(0.95),
              colorText: Colors.white,
              icon: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              shouldIconPulse: false,
              isDismissible: true,
              dismissDirection: DismissDirection.horizontal,
              forwardAnimationCurve: Curves.easeOutBack,
              reverseAnimationCurve: Curves.easeInBack,
              animationDuration: const Duration(milliseconds: 300),
              borderRadius: 12,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              snackPosition: SnackPosition.TOP,
              titleText: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              messageText: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              mainButton: TextButton(
                onPressed: () => Get.closeCurrentSnackbar(),
                child: Text(
                  'Dismiss',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              boxShadows: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            );
            log("Get.snackbar displayed on UI thread");
          } catch (e) {
            log("ERROR in delayed snackbar: $e");
            // Fallback to simple snackbar
            Get.snackbar(title, message, duration: duration);
          }
        });
      });

      log("Get.snackbar scheduled for UI thread");
    } catch (e) {
      log("ERROR showing Get.snackbar: $e");
      // Fallback to simple snackbar if custom one fails
      Get.snackbar(title, message, duration: duration);
    }
  }

  static void closeAllToasts() {
    try {
      Get.closeAllSnackbars();
    } catch (e) {
      log("Error closing snackbars: $e");
    }
  }

  // Test method to verify snackbar functionality
  static void testSnackbar() {
    log("Testing snackbar functionality...");
    
    // Ensure we're on the main UI thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "Test",
        "This is a test snackbar - should be visible!",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        isDismissible: true,
      );
      log("Test snackbar displayed");
    });
  }

  // Simple test method without custom styling
  static void testSimpleSnackbar() {
    log("Testing simple snackbar...");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar("Simple Test", "Simple snackbar test");
      log("Simple test snackbar displayed");
    });
  }
}
