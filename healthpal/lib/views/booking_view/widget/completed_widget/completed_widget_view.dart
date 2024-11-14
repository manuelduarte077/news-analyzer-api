import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/widgets/app_AppointmentCard/app_appointment_card_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';

class CompletedWidgetView extends StatefulWidget {
  const CompletedWidgetView({super.key});

  @override
  State<CompletedWidgetView> createState() => _CompletedWidgetViewState();
}

class _CompletedWidgetViewState extends State<CompletedWidgetView> {
  final List<Map<String, dynamic>> completeBooking = [
    {
      'date': 'June 15, 2024',
      'doctorName': 'Dr. John Doe',
      'specialty': 'Cardiologist',
      'clinic': 'Heart Care Clinic',
      'image': LocalImages.icFavoriteDoctor1Icon,
      'icon': Icons.location_on,
    },
    {
      'date': 'June 20, 2024',
      'doctorName': 'Dr. Jane Smith',
      'specialty': 'Dermatologist',
      'clinic': 'Skin Health Clinic',
      'image': LocalImages.icFavoriteDoctor2Icon,
      'icon': Icons.location_on,
    },
    {
      'date': 'June 15, 2024',
      'doctorName': 'Dr. John Doe',
      'specialty': 'Cardiologist',
      'clinic': 'Heart Care Clinic',
      'image': LocalImages.icFavoriteDoctor3Icon,
      'icon': Icons.location_on,
    },
    {
      'date': 'June 20, 2024',
      'doctorName': 'Dr. Jane Smith',
      'specialty': 'Dermatologist',
      'clinic': 'Skin Health Clinic',
      'image': LocalImages.icFavoriteDoctor4Icon,
      'icon': Icons.location_on,
    },
    {
      'date': 'June 15, 2024',
      'doctorName': 'Dr. John Doe',
      'specialty': 'Cardiologist',
      'clinic': 'Heart Care Clinic',
      'image': LocalImages.icIntroImgFirst,
      'icon': Icons.location_on,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: completeBooking.length,
        itemBuilder: (context, index) {
          final booking = completeBooking[index];
          return Column(
            children: [
              AppAppointmentCardView(
                date: booking['date'],
                doctorName: booking['doctorName'],
                specialty: booking['specialty'],
                icon: booking['icon'],
                clinic: booking['clinic'],
                image: booking['image'],
                actions: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButtonView(
                          color: AppColors.whiteColor,
                          textColor: AppColors.blackColor,
                          border: Border.all(color: AppColors.mirageColor),
                          text: 'Re-Book',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButtonView(
                          text: 'Add Review',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
