import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';

class ProfileMenuItemView extends StatelessWidget {
  final String? image;
  final String? text;
  final String? icon;
  final double? height;
  final double? width;

  const ProfileMenuItemView({
    super.key,
    this.image,
    this.text,
    this.icon,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Row(
        children: [
          Image.asset(image ?? '', height: height, width: width),
          const SizedBox(width: 10),
          Text(
            text ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.paleSkyColor,
            ),
          ),
          const Spacer(),
          if (icon != null && icon!.isNotEmpty)
            Image.asset(
              icon!,
              height: height,
              width: width,
              color: AppColors.paleSkyColor,
            ),
        ],
      ),
    );
  }
}
