

import 'dart:io';

import 'package:flutter/material.dart';
import 'app_extension.dart';
import 'custom_login_indi.dart';

class CustomNetworkImage extends StatelessWidget {
  final double? width, height, errorWidth, errorHeight;
  final double radius;
  final String? imageUrl, errorImage, otherImage;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Decoration? decoration;
  final BorderRadiusGeometry? borderRadius;

  final File? imageFile;
  const CustomNetworkImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.radius = 0,
    this.fit,
    this.errorWidth,
    this.errorHeight,
    this.errorWidget,
    this.errorImage,
    this.otherImage,
    this.decoration,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        child: imageFile != null
            ? Image.file(
          imageFile!,
          width: width,
          height: height,
          fit: fit ?? BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => SizedBox(
            width: errorWidth ?? width,
            height: errorHeight ?? height,
            child: errorWidget ?? Image.asset(errorImage ?? "Graphics.instance.noImage", fit: fit ?? BoxFit.fill),
          ),
        )
            : imageUrl.notEmptyNotNull
            ? Container()
            : SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            otherImage ?? "Graphics.instance.banner",
            fit: fit ?? BoxFit.fill,
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}
// CachedNetworkImage(
// width: width,
// height: height,
// imageUrl: imageUrl!,
// progressIndicatorBuilder: (context, url, downloadProgress) => Center(
// child: SizedBox(
// width: 25,
// height: 25,
// child: CustomLoadingIndicator(value: downloadProgress.progress),
// ),
// ),
// fit: fit ?? BoxFit.fill,
// fadeInDuration: Duration.zero,
// errorWidget: (context, url, error) => SizedBox(
// width: errorWidth ?? width,
// height: errorHeight ?? height,
// child: errorWidget ?? Image.asset(errorImage ?? "Graphics.instance.memberPlaceholder", fit: fit ?? BoxFit.fill),
// ),
// filterQuality: FilterQuality.high,
// )