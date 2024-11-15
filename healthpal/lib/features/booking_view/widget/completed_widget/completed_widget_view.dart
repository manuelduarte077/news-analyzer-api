import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';
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
      'date': '15 de junio de 2024',
      'doctorName': 'Dr. Juan Pérez',
      'specialty': 'Cardiólogo',
      'clinic': 'Clínica de Cuidado del Corazón',
      'image': LocalImages.icFavoriteDoctor1Icon,
      'icon': Icons.location_on,
    },
    {
      'date': '20 de junio de 2024',
      'doctorName': 'Dra. Diana Smith',
      'specialty': 'Dermatóloga',
      'clinic': 'Clínica de Salud de la Piel',
      'image': LocalImages.icFavoriteDoctor2Icon,
      'icon': Icons.location_on,
    },
    {
      'date': '15 de junio de 2024',
      'doctorName': 'Dr. Manuel García',
      'specialty': 'Cardiólogo',
      'clinic': 'Clínica de Cuidado del Corazón',
      'image': LocalImages.icFavoriteDoctor3Icon,
      'icon': Icons.location_on,
    },
    {
      'date': '20 de junio de 2024',
      'doctorName': 'Dra. Olivia Pérez',
      'specialty': 'Dermatóloga',
      'clinic': 'Clínica de Salud de la Piel',
      'image': LocalImages.icFavoriteDoctor4Icon,
      'icon': Icons.location_on,
    },
    {
      'date': '15 de junio de 2024',
      'doctorName': 'Dr. Enrique González',
      'specialty': 'Cardiólogo',
      'clinic': 'Clínica de Cuidado del Corazón',
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
                          text: 'Reprogramar',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButtonView(
                          text: 'Agregar Reseña',
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
