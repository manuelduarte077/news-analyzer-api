import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';
import 'package:healthpal/features/doctor_details/doctor_details_view.dart';

class MyDoctorView extends StatefulWidget {
  const MyDoctorView({super.key});

  @override
  State<MyDoctorView> createState() => _MyDoctorViewState();
}

class _MyDoctorViewState extends State<MyDoctorView> {
  final List<Map<String, dynamic>> doctorDetails = [
    {
      'image': LocalImages.icFavoriteDoctor1Icon,
      'name': 'Dr. Manuel Espinoza',
      'degree': 'Pediatra',
      'location': 'Hospital Primario Bilwi, Bilwi, Puerto Cabezas',
      'rating': '4.7',
      'review': '1,120 Reviews',
      'isFavorite': true,
    },
    {
      'image': LocalImages.icFavoriteDoctor2Icon,
      'name': 'Dra. Teresa Rivera',
      'degree': 'Ginecóloga',
      'location': 'Hospital Regional Nuevo Amanecer, Bluefields, RAAS',
      'rating': '4.8',
      'review': '980 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icFavoriteDoctor3Icon,
      'name': 'Dr. José Baltodano',
      'degree': 'Cardiólogo',
      'location': 'Clínica Esperanza, Bluefields, RAAS',
      'rating': '4.6',
      'review': '1,450 Reviews',
      'isFavorite': true,
    },
    {
      'image': LocalImages.icFavoriteDoctor4Icon,
      'name': 'Dra. Rosa Zamora',
      'degree': 'Médico General',
      'location': 'Centro de Salud Kukra Hill, Kukra Hill, RAAS',
      'rating': '4.4',
      'review': '670 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icIntroImgFirst,
      'name': 'Dr. Carlos Obando',
      'degree': 'Cirujano General',
      'location': 'Hospital Materno Infantil, Bluefields, RAAS',
      'rating': '4.9',
      'review': '1,200 Reviews',
      'isFavorite': true,
    },
    {
      'image': LocalImages.icFavoriteDoctor1Icon,
      'name': 'Dra. María Gutiérrez',
      'degree': 'Dermatóloga',
      'location': 'Clínica San Carlos, Corn Island, RAAS',
      'rating': '4.5',
      'review': '760 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icFavoriteDoctor2Icon,
      'name': 'Dr. Roberto Mena',
      'degree': 'Odontólogo',
      'location': 'Centro de Salud Prinzapolka, Prinzapolka, RAAN',
      'rating': '4.3',
      'review': '540 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icFavoriteDoctor3Icon,
      'name': 'Dra. Juana Pérez',
      'degree': 'Oftalmóloga',
      'location': 'Clínica Médica Kukra River, Kukra River, RAAS',
      'rating': '4.6',
      'review': '620 Reviews',
      'isFavorite': true,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: doctorDetails.length,
        itemBuilder: (context, index) {
          final doctor = doctorDetails[index];
          return GestureDetector(
            onTap: () {
              Navigation.push(
                context,
                DoctorDetailsView(doctor: doctor),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      doctor['image'],
                      height: 109,
                      width: 109,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['name'],
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          const Divider(height: 2),
                          SizedBox(height: 10),
                          Text(
                            doctor['degree'],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              Expanded(
                                child: Text(
                                  doctor['location'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 20.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                doctor['rating'],
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              const SizedBox(
                                height: 16,
                                child: VerticalDivider(
                                  color: AppColors.silverColor,
                                  thickness: 2,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                doctor['review'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
