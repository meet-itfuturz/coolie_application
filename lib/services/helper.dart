import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  final ImagePicker _picker = ImagePicker();

  Future<void> launchURL(String val) async {
    if (await canLaunchUrl(Uri.parse(val))) {
      await launchUrl(Uri.parse(val));
    } else {
      throw 'Could not launch $val';
    }
  }

  Future<File?> pickImage({ImageSource? source}) async {
    try {
      final XFile? file = await _picker.pickImage(source: source ?? ImageSource.camera);
      if (file != null) {
        return File(file.path);
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<int> getFileSize(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        int fileSize = await file.length();
        return fileSize;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  void shareOnWhatsApp(String message, String phoneNumber) async {
    try {
      String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final String encodedMessage = Uri.encodeComponent(message);
      final Uri whatsappUri = Uri.parse('https://wa.me/$cleanedNumber?text=$encodedMessage');
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
      }
    } catch (e) {
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(launchUri);
    } catch (err) {
    }
  }

  void sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(launchUri);
    } catch (err) {
    }
  }

  Future<File?> cropImageByPath(String imagePath, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          statusBarColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.black,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [CropAspectRatioPreset.original, CropAspectRatioPreset.square],
          cropFrameStrokeWidth: 2,
          showCropGrid: true,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  String extractLast10Digits(String input) {
    String digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  bool isMobileValidation(String phoneNumber) {
    String regexPattern = r'^[6-9][0-9]{9}$';
    var regExp = RegExp(regexPattern);
    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }

  Future<String> getDeviceUniqueId() async {
    String deviceIdentifier = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }
    return deviceIdentifier;
  }

  Widget loadingWidget({Color? color, double? strokeWidth, double? size}) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size ?? 25,
            width: size ?? 25,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 3,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.black),
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String scheduleTimeFormate(String time) {
    if (time.isNotEmpty) {
      try {
        final today = DateTime.now().toUtc();
        final startParts = time.split(':');
        if (startParts.length != 2) throw Exception('Invalid time format');
        final startHour = int.parse(startParts[0]);
        final startMinute = int.parse(startParts[1]);
        final utcStart = DateTime.utc(today.year, today.month, today.day, startHour, startMinute);
        final istStart = utcStart.add(const Duration(hours: 5, minutes: 30));
        String formatTime(DateTime dt) {
          int hour = dt.hour % 12;
          if (hour == 0) hour = 12;
          final minute = dt.minute.toString().padLeft(2, '0');
          final amPM = dt.hour < 12 ? 'AM' : 'PM';
          return '$hour:$minute $amPM';
        }

        return formatTime(istStart);
      } catch (e) {
        return '';
      }
    }
    return '';
  }

  String formatScanTime(String dtStr) {
    final utcTime = DateTime.parse(dtStr);
    const kolkataOffset = Duration(hours: 5, minutes: 30);
    final kolkataTime = utcTime.add(kolkataOffset);
    final now = DateTime.now().toUtc().add(kolkataOffset);
    String additionalText = "";
    if (kolkataTime.year == now.year && kolkataTime.month == now.month && kolkataTime.day == now.day) {
      additionalText = "Today";
    } else if (kolkataTime.year == now.year && kolkataTime.month == now.month && kolkataTime.day == now.day - 1) {
      additionalText = "Yesterday";
    }
    bool isSameYear = kolkataTime.year == now.year;
    String dateFormat = isSameYear ? (additionalText.isNotEmpty ? "" : "dd MMM") : "dd MMM yyyy";
    String formattedDate = DateFormat(dateFormat, 'en_US').format(kolkataTime);
    return "$additionalText$formattedDate";
  }
}

Helper helper = Helper();
