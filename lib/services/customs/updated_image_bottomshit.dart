

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UpdateImagesBottomShit extends StatelessWidget {
  final GestureTapCallback? onView;
  final GestureTapCallback? onUpdate;
  final GestureTapCallback? onRemove;
  final bool? isCheck;

  const UpdateImagesBottomShit({
    super.key,
    this.onView,
    this.onUpdate,
    this.onRemove,
    this.isCheck
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isCheck==true? _card(
           // svg: "Graphics.instance.editPen",
          // color: Constants.instance.black,
          icon: Icons.camera_alt_outlined,
          value: "Camera",
          onTap: onView,
        ):Container(),
        // Constants.instance.square.copyWith(height: 5),
        _card(
           // svg: "Graphics.instance.gallery",
          icon: Icons.photo_camera_back_outlined,
          size: 21,
          value: "Gallery",
          onTap: onUpdate,
        ),

        // isCheck==true? _card(
        //   svg: Graphics.instance.delete,
        //   value: "Remove",
        //   size: 20,
        //   color: Constants.instance.errorToast,
        //   style: AppTextStyle.regular.copyWith(fontSize: 13.5, color: Constants.instance.errorToast),
        //   onTap: onRemove,
        // ):Container(),
      ],
    );
  }

  Widget _card({
    // required String svg,
    required IconData icon,
    required String value,
    TextStyle? style,
    Color? color,
    GestureTapCallback? onTap,
    double? size,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          child: Row(
            children: [
              // SvgPicture.asset(
              //   svg,
              //   width: size ?? 22,
              //   height: size ?? 22,
              //   colorFilter: ColorFilter.mode(color ?? Colors.grey.shade600, BlendMode.srcIn),
              // ),
              Icon(icon),
              SizedBox(width: 10,),
              // Constants.instance.square.copyWith(height: 0, width: 10),
              Text(value, style: style ?? TextStyle(fontSize: 14.5, color: Colors.grey.shade700)),
            ],
          ),
        ),
      );
}
