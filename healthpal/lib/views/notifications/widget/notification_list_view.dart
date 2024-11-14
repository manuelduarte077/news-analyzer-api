import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';

class NotificationsListView extends StatelessWidget {
  final String? dayName;
  final String? title;
  final int? itemCount;

  NotificationsListView({this.dayName, this.title, this.itemCount, super.key});

  final List<Map<String, dynamic>> notificationsDetails = [
    {
      'image': LocalImages.icAppointmentSuccessIcon,
      'backgroundColor': AppColors.grannyAppleColor,
      'appointmentStatus': 'Cita Exitosa',
      'statusDescription':
          'Has reservado exitosamente tu\ncita con la Dra. Emily Walker.',
      'time': '1h',
    },
    {
      'image': LocalImages.icAppointmentCancelledIcon,
      'backgroundColor': AppColors.cinderellaColor,
      'appointmentStatus': 'Cita Cancelada',
      'statusDescription':
          'Has cancelado exitosamente tu\ncita con el Dr. David Patel.',
      'time': '2h'
    },
    {
      'image': LocalImages.icAppointmentScheduledChangedIcon,
      'backgroundColor': AppColors.silverColor,
      'appointmentStatus': 'Cita Reprogramada',
      'statusDescription':
          'Has cambiado exitosamente tu\ncita con la Dra. Jesica Turner.',
      'time': '3h'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayName ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.silverColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount ?? notificationsDetails.length,
            itemBuilder: (context, index) {
              final notification = notificationsDetails[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: notification['backgroundColor'],
                      ),
                      child: Image.asset(
                        notification['image'],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['appointmentStatus'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Text(
                            notification['statusDescription'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.paleSkyColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      notification['time'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.silverColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
