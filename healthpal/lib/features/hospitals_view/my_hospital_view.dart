import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';

class MyHospitalView extends StatefulWidget {
  const MyHospitalView({super.key});

  @override
  State<MyHospitalView> createState() => _MyHospitalViewState();
}

class _MyHospitalViewState extends State<MyHospitalView> {
  List<Map<String, dynamic>> hospitalDetails = [
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Hospital Primario Bilwi',
      'location': 'Bilwi, Puerto Cabezas',
      'rating': '4.5',
      'review': '1,250 Reviews',
      'directions': '3 km/45min',
      'hospital': 'Hospital',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Clínica Esperanza',
      'location': 'Bluefields, RAAS',
      'rating': '4.7',
      'review': '980 Reviews',
      'directions': '1.5 km/20min',
      'hospital': 'Clínica',
      'isFavorite': true,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Centro de Salud Kukra Hill',
      'location': 'Kukra Hill, RAAS',
      'rating': '4.2',
      'review': '730 Reviews',
      'directions': '5 km/1h 10min',
      'hospital': 'Centro de Salud',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Hospital Regional Nuevo Amanecer',
      'location': 'Bluefields, RAAS',
      'rating': '4.8',
      'review': '2,150 Reviews',
      'directions': '2 km/30min',
      'hospital': 'Hospital',
      'isFavorite': true,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Clínica San Carlos',
      'location': 'Corn Island, RAAS',
      'rating': '4.4',
      'review': '540 Reviews',
      'directions': '0.8 km/15min',
      'hospital': 'Clínica',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Centro de Salud Prinzapolka',
      'location': 'Prinzapolka, RAAN',
      'rating': '4.1',
      'review': '620 Reviews',
      'directions': '6 km/1h 20min',
      'hospital': 'Centro de Salud',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Hospital Materno Infantil',
      'location': 'Bluefields, RAAS',
      'rating': '4.6',
      'review': '1,340 Reviews',
      'directions': '1.2 km/25min',
      'hospital': 'Hospital',
      'isFavorite': true,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Clínica Médica Kukra River',
      'location': 'Kukra River, RAAS',
      'rating': '4.3',
      'review': '480 Reviews',
      'directions': '3.2 km/50min',
      'hospital': 'Clínica',
      'isFavorite': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: hospitalDetails.length,
      itemBuilder: (context, index) {
        final hospital = hospitalDetails[index];

        return Container(
          width: 375,
          height: 280,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: Image.asset(
                      hospital['image'],
                      width: double.infinity,
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 1,
                    child: IconButton(
                      icon: Icon(
                        hospital['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: hospital['isFavorite']
                            ? Colors.red
                            : AppColors.paleSkyColor,
                      ),
                      onPressed: () {
                        setState(() {
                          hospital['isFavorite'] = !hospital['isFavorite'];
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.riverBedColor,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          hospital['location'],
                          style: const TextStyle(
                            color: Colors.grey,
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
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          hospital['rating'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          hospital['review'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_walk,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          hospital['directions'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.local_hospital,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          hospital['hospital'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
