import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';

class DoctorDetailsReviewsCardView extends StatelessWidget {
  const DoctorDetailsReviewsCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    AssetImage(LocalImages.icDoctorDetailsReviewProfileIcon),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emily Anderson',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        '5.0',
                        style: TextStyle(
                          color: AppColors.silverColor,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone looking for quality care.',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
