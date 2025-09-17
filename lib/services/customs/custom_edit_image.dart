

import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import 'custom_icon_button.dart';
import 'custom_network_image.dart';


class CustomEditableImageView extends StatelessWidget {
  final String? otherImage, imageUrl;
  final File? imageFile;
  final double? radius;
  final double? width, height, editBtnSize;
  final BoxFit? fit;
  final bool isEdited;
  final String? label;
  final GestureTapCallback? onEdit;
  final String? errorImage;
  final Widget? errorWidget;

  const CustomEditableImageView({
    super.key,
    this.otherImage,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.editBtnSize,
    this.fit,
    this.isEdited = true,
    this.onEdit,
    this.label,
    this.radius,
    this.errorImage,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              //! Image View
              if (imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius ?? 0),
                  child: Image.file(
                    imageFile!,
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.cover,
                  ),
                )
              else if (imageUrl != null && imageUrl!.isNotEmpty)
                CustomNetworkImage(
                  radius: radius ?? 0,
                  width: width,
                  height: height,
                  imageUrl: imageUrl,
                  imageFile: imageFile,
                  otherImage: otherImage,
                  errorImage: errorImage,
                  errorWidget: errorWidget,
                  fit: fit ?? BoxFit.cover,
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius ?? 0),
                  child: Image.asset(
                    otherImage ?? '',
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.cover,
                  ),
                ),

              //! EDIT
              if (isEdited && onEdit != null)
                Positioned(
                  bottom: 6,
                  right: 2,
                  child: Material(
                    elevation: 2,
                    shape: CircleBorder(),
                    color: Colors.transparent,
                    child: CustomIconBtn(
                      bgColor: Constants.instance.primary,
                      radius: editBtnSize ?? 25,
                      width: editBtnSize ?? 25,
                      height: editBtnSize ?? 25,
                      svgHeight: 16,
                      svgWidth: 16,
                      svg:Icon(Icons.edit,color: Constants.instance.white,size: 15,),
                      color: Colors.white,
                      border: Border.all(color: Constants.instance.primary),
                      onTap: onEdit,
                    ),
                  ),
                )
            ],
          ),
        ),
        // if (label.notEmptyNotNull) ...[
        //   Constants.instance.square.copyWith(height: 06),
        //   Text(
        //     "$label",
        //     style: AppTextStyle.medium.copyWith(
        //       fontSize: 12,
        //       color: Constants.instance.grey700,
        //     ),
        //   ),
        // ]
      ],
    );
  }
}
