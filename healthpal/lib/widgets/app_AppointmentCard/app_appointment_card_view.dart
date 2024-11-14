import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';

class AppAppointmentCardView extends StatelessWidget {
  final String? date;
  final String? doctorName;
  final String? specialty;
  final String? clinic;
  final String? image;
  final Widget? actions;
  final IconData? icon;

  const AppAppointmentCardView({
    super.key,
    this.date,
    this.doctorName,
    this.specialty,
    this.clinic,
    this.image,
    this.actions,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 10) +
          const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date ?? '',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: AppColors.silverColor),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.asset(
                    image ?? LocalImages.icIntroImgFirst,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName ?? '',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      specialty ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Icon(icon),
                        Text(
                          clinic ?? '',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.silverColor),
          if (actions != null) ...[
            const SizedBox(height: 10),
            actions!,
          ]
        ],
      ),
    );
  }
}
