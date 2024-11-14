import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';

class MyHospitalView extends StatefulWidget {
  const MyHospitalView({super.key});

  @override
  State<MyHospitalView> createState() => _MyHospitalViewState();
}

class _MyHospitalViewState extends State<MyHospitalView> {
  List<Map<String, dynamic>> hospitalDetails = [
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'location': '123 Oak Street, CA 98765',
      'rating': '5',
      'review': '1,872 Reviews',
      'directions': '2.5 km/40min',
      'hospital': 'Hospital',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'location': '123 Oak Street, CA 98765',
      'rating': '5',
      'review': '1,872 Reviews',
      'directions': '2.5 km/40min',
      'hospital': 'Hospital',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'location': '123 Oak Street, CA 98765',
      'rating': '5',
      'review': '1,872 Reviews',
      'directions': '2.5 km/40min',
      'hospital': 'Hospital',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'location': '123 Oak Street, CA 98765',
      'rating': '5',
      'review': '1,872 Reviews',
      'directions': '2.5 km/40min',
      'hospital': 'Hospital',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Sunrise Health Clinic',
      'location': '123 Oak Street, CA 98765',
      'rating': '5',
      'review': '1,872 Reviews',
      'directions': '2.5 km/40min',
      'hospital': 'Hospital',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: hospitalDetails.length,
      itemBuilder: (context, index) {
        final hospital = hospitalDetails[index];
        return Container(
          width: 375,
          height: 280,
          margin: const EdgeInsets.all(16.0),
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
