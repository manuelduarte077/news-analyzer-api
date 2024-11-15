import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';

class HospitalDetailsView extends StatelessWidget {
  final void Function(double latitude, double longitude) onCardTap;

  const HospitalDetailsView({super.key, required this.onCardTap});

  static const List<Map<String, dynamic>> medicalCenters = [
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Hospital Primario Bilwi',
      'address': 'Barrio El Muelle, Bilwi, Puerto Cabezas',
      'rating': 4.5,
      'reviewsCount': 100,
      'distance': 5.5,
      'category': 'Hospital',
      'isFavorite': false,
      'latitude': 14.0384,
      'longitude': -83.3888,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Clínica Esperanza',
      'address': 'Calle Central, Bluefields, RAAS',
      'rating': 4.8,
      'reviewsCount': 120,
      'distance': 7.2,
      'category': 'Clínica',
      'isFavorite': false,
      'latitude': 12.0006,
      'longitude': -83.7645,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Hospital Regional Nuevo Amanecer',
      'address': 'Barrio Pancasán, Bluefields, RAAS',
      'rating': 4.7,
      'reviewsCount': 150,
      'distance': 3.8,
      'category': 'Hospital',
      'isFavorite': true,
      'latitude': 12.0105,
      'longitude': -83.7706,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Centro de Salud Kukra Hill',
      'address': 'Calle Principal, Kukra Hill, RAAS',
      'rating': 4.2,
      'reviewsCount': 90,
      'distance': 6.1,
      'category': 'Centro de Salud',
      'isFavorite': false,
      'latitude': 12.2315,
      'longitude': -83.6702,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Clínica San Carlos',
      'address': 'Calle Principal, Corn Island, RAAS',
      'rating': 4.3,
      'reviewsCount': 85,
      'distance': 2.5,
      'category': 'Clínica',
      'isFavorite': false,
      'latitude': 12.1686,
      'longitude': -83.0475,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: medicalCenters.length,
        itemBuilder: (context, index) {
          final center = medicalCenters[index];

          return GestureDetector(
            onTap: () {
              onCardTap(center['latitude'], center['longitude']);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Card(
                color: Colors.white.withOpacity(0.8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              center['image'],
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                center['isFavorite'] = !center['isFavorite'];
                              },
                              child: Icon(
                                center['isFavorite']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: center['isFavorite']
                                    ? Colors.red
                                    : AppColors.silverColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        center['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.riverBedColor,
                        ),
                      ),
                      Text(
                        center['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.paleSkyColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Divider(color: AppColors.silverColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${center["distance"]} km away',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.paleSkyColor,
                            ),
                          ),
                          Text(
                            center['category'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.paleSkyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
