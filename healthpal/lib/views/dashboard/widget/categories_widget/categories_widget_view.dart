import 'package:flutter/material.dart';

class CategoriesWidgetView extends StatelessWidget {
  final String image;
  final String? text;
  const CategoriesWidgetView(
      {super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(image, height: 59),
        Text(
          text ?? '',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
