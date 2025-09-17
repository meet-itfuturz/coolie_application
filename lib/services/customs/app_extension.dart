

import 'package:flutter/cupertino.dart';

extension Sizer on SizedBox {
  SizedBox copyWith({double? width, double? height}) => SizedBox(
    width: width ?? this.width,
    height: height ?? this.height,
  );
}

extension OnString on String? {
  bool get notEmptyNotNull {
    return this != null && this!.trim().isNotEmpty && runtimeType != Null;
  }

  String get checkDash {
    return notEmptyNotNull ? this! : '-';
  }

  String get checkEmpty {
    return notEmptyNotNull ? this! : '';
  }
}
