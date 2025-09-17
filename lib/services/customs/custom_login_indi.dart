import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.isIosStyle = false,
    this.dimension = 15,
    this.color,
    this.strokeWidth = 1.6,
    this.backgroundColor,
    this.value,
  });
  final bool isIosStyle;
  final double dimension, strokeWidth;
  final Color? color, backgroundColor;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: dimension,
        child: isIosStyle
            ? CupertinoActivityIndicator(
          animating: true,
          color: color ?? Constants.instance.black,
        )
            : CircularProgressIndicator(
          color: color ?? Constants.instance.black,
          value: value,

          // backgroundColor: backgroundColor ?? Constants.instance.primary15,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
