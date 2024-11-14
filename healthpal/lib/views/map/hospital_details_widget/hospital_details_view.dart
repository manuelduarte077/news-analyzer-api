import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';

class HospitalDetailsView extends StatefulWidget {
  const HospitalDetailsView({super.key});

  @override
  State<HospitalDetailsView> createState() => _HospitalDetailsViewState();
}

class _HospitalDetailsViewState extends State<HospitalDetailsView> {
  final List<Map<String, dynamic>> medicalCenters = [
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'address': '1234 Main St, City',
      'rating': 4.5,
      'reviewsCount': 100,
      'distance': 5.5,
      'category': 'Hospitle',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Golden Cardiology Center',
      'address': '5678 Elm St, City',
      'rating': 4.8,
      'reviewsCount': 120,
      'distance': 7.2,
      'category': 'Hospitle',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'address': '91011 Oak St, City',
      'rating': 4.2,
      'reviewsCount': 90,
      'distance': 3.8,
      'category': 'Hospitle',
      'isFavorite': false,
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
          return Padding(
            padding: const EdgeInsets.all(2.5),
            child: Card(
              color: Colors.white.withOpacity(0.8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8.0),
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
                              setState(() {
                                center['isFavorite'] = !center['isFavorite'];
                              });
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
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: AppColors.petiteOrchidColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          center['rating'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.paleSkyColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${center["reviewsCount"]} reviews)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.paleSkyColor,
                          ),
                        ),
                      ],
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
          );
        },
      ),
    );
  }
}
