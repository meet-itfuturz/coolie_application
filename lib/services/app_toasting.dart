import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

class AppToasting {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static Completer<void>? _toastCompleter;

  static void showSuccess(String message, {String title = 'Success', Duration duration = const Duration(seconds: 3)}) {
    _showToast(message, title: title, backgroundColor: Colors.green, icon: Icons.check_circle, duration: duration);
  }

  static void showError(String message, {String title = 'Error', Duration duration = const Duration(seconds: 3)}) {
    _showToast(message, title: title, backgroundColor: Colors.red, icon: Icons.error, duration: duration);
  }

  static void showWarning(String message, {String title = 'Warning', Duration duration = const Duration(seconds: 3)}) {
    _showToast(message, title: title, backgroundColor: Colors.orange, icon: Icons.warning, duration: duration);
  }

  static void showInfo(String message, {String title = 'Info', Duration duration = const Duration(seconds: 3)}) {
    _showToast(message, title: title, backgroundColor: Colors.blue, icon: Icons.info, duration: duration);
  }

  static void _showToast(
    String message, {
    required String title,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Close any existing toast first
    closeAllToasts();

    // Wait a frame to ensure cleanup is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        log("Showing toast via ScaffoldMessenger: $title - $message");

        final messenger = scaffoldMessengerKey.currentState;
        if (messenger != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: backgroundColor.withOpacity(0.95),
              duration: duration,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              elevation: 6,
              action: SnackBarAction(label: 'Dismiss', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
            ),
          );
          log("Toast shown successfully");
        } else {
          log("ERROR: ScaffoldMessenger not available");
        }
      } catch (e) {
        log("ERROR showing toast: $e");
      }
    });
  }

  static void closeAllToasts() {
    try {
      scaffoldMessengerKey.currentState?.clearSnackBars();
    } catch (e) {
      log("Error closing toasts: $e");
    }
  }
}
