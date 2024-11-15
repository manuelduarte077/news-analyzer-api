import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';

class OrDivider extends StatelessWidget {
  final String? text;

  const OrDivider({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(
            color: AppColors.silverColor,
            thickness: 1,
            endIndent: 10,
          ),
        ),
        Text(
          text ?? '',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.silverColor,
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.silverColor,
            thickness: 1,
            indent: 10,
          ),
        ),
      ],
    );
  }
}
