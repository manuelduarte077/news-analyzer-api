import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';

class AppButtonView extends StatelessWidget {
  final double? height;
  final double? imgHeight;
  final double? width;
  final double? iconTextWidth;
  final Color? color;
  final String? text;
  final Color? textColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final String? image;
  final bool? isImage;
  final bool? isSizeBox;
  final Function? onTap;

  const AppButtonView({
    super.key,
    this.height,
    this.imgHeight,
    this.iconTextWidth,
    this.width,
    this.color,
    this.onTap,
    required this.text,
    this.textColor,
    this.border,
    this.borderRadius,
    this.isImage = false,
    this.isSizeBox = false,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as Function(),
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? AppColors.mirageColor,
          borderRadius: borderRadius ?? BorderRadius.circular(50),
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImage == true
                ? Image.asset(
                    image ?? '',
                    height: imgHeight ?? 10,
                  )
                : const SizedBox.shrink(),
            isSizeBox == true
                ? SizedBox(width: iconTextWidth ?? 06)
                : const SizedBox.shrink(),
            Text(
              text ?? '',
              style: TextStyle(
                fontSize: 18,
                color: textColor ?? AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
