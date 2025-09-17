

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_constants.dart';
import 'custom_login_indi.dart';

class CustomIconBtn extends StatelessWidget {
  const CustomIconBtn({
    super.key,
    this.svgPath,
    this.svg,
    this.color,
    this.bgColor,
    this.width,
    this.height,
    this.padding,
    this.radius = 10,
    this.svgWidth,
    this.svgHeight,
    this.onTap,
    this.border,
    this.isLoading = false,
  }) : assert(!(svgPath != null && svg != null), "You can't use svg and svgPath at same-time");
  final String? svgPath;
  final Widget? svg;
  final Color? color, bgColor;
  final double? width, height, svgWidth, svgHeight;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;
  final BoxBorder? border;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isLoading ? onTap : null,
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        width: width ?? 40,
        height: height ?? 40,
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor ?? Constants.instance.white,
          borderRadius: BorderRadius.circular(radius),
          border: border,
        ),
        child: Center(
          child: isLoading
              ? CustomLoadingIndicator(dimension: 10)
              : svgPath != null
              ? SvgPicture.asset(
            svgPath!,
            fit: BoxFit.fill,
            width: svgWidth,
            height: svgHeight,
            colorFilter: ColorFilter.mode(color ?? Constants.instance.transparent, BlendMode.srcIn),
          )
              : svg,
        ),
      ),
    );
  }
}
