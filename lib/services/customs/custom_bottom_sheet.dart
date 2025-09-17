import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_constants.dart';

Future<T?> openBottomShit<T>({
  required Widget child,
  bool isDismissible = true,
  Color? barrierColor,
  bool? ignoreSafeArea,
  RouteSettings? settings,
  bool readySetup = false,
  String? title,
  TextStyle? style,
}) => Get.bottomSheet(
  backgroundColor: Constants.instance.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  elevation: 0.75,
  isDismissible: isDismissible,
  barrierColor: barrierColor,
  ignoreSafeArea: ignoreSafeArea,
  settings: settings,
  readySetup
      ? SizedBox(
    width: double.maxFinite,
    child: Padding(
      padding: Constants.instance.popupPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Text(
                "$title",
                style: style ?? TextStyle(fontSize: 15, color: Constants.instance.black),
              ),
              // CustomCloseBtn(size: 25),
            ],
          ),
          Constants.instance.square,
          child,
        ],
      ),
    ),
  )
      : child,
);