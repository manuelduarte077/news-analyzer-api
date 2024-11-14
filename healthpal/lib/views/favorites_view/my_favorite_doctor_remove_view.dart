import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';

class MyFavoriteDoctorRemoveView extends StatefulWidget {
  const MyFavoriteDoctorRemoveView({super.key});

  @override
  State<MyFavoriteDoctorRemoveView> createState() =>
      _MyFavoriteDoctorRemoveViewState();
}

class _MyFavoriteDoctorRemoveViewState
    extends State<MyFavoriteDoctorRemoveView> {
  final List<Map<String, dynamic>> doctorDetails = [
    {
      'image': LocalImages.icFavoriteDoctor1Icon,
      'name': 'Dr. David Patel',
      'degree': 'Cardiologist',
      'location': 'Cardiology Center, USA',
      'rating': '5',
      'review': '1,872 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icFavoriteDoctor2Icon,
      'name': 'Dr. David Patel',
      'degree': 'Cardiologist',
      'location': 'Cardiology Center, USA',
      'rating': '5',
      'review': '1,872 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icFavoriteDoctor3Icon,
      'name': 'Dr. David Patel',
      'degree': 'Cardiologist',
      'location': 'Cardiology Center, USA',
      'rating': '5',
      'review': '1,872 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icFavoriteDoctor4Icon,
      'name': 'Dr. David Patel',
      'degree': 'Cardiologist',
      'location': 'Cardiology Center, USA',
      'rating': '5',
      'review': '1,872 Reviews',
      'isFavorite': false,
    },
    {
      'image': LocalImages.icIntroImgFirst,
      'name': 'Dr. David Patel',
      'degree': 'Cardiologist',
      'location': 'Cardiology Center, USA',
      'rating': '5',
      'review': '1,872 Reviews',
      'isFavorite': false,
    },
  ];

  void _showRemoveBottomSheet(
      BuildContext context, Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 325,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Remove from Favorites?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mirageColor,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  doctor['name'],
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    doctor['isFavorite']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: doctor['isFavorite']
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      doctor['isFavorite'] =
                                          !doctor['isFavorite'];
                                    });
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 1),
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
                                const SizedBox(
                                    width:
                                        0), // Add spacing between the icon and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor['location'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: AppButtonView(
                      color: AppColors.athensGrayColor,
                      textColor: AppColors.mirageColor,
                      border: Border.all(color: AppColors.mirageColor),
                      text: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AppButtonView(
                      color: AppColors.mirageColor,
                      textColor: AppColors.athensGrayColor,
                      border: Border.all(color: AppColors.mirageColor),
                      text: 'Yes, Remove',
                      onTap: () {
                        setState(() {
                          doctorDetails.remove(doctor);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
              _showRemoveBottomSheet(context, doctor);
            },
            child: Container(
              height: 160,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                doctor['name'],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  doctor['isFavorite']
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: doctor['isFavorite']
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    doctor['isFavorite'] =
                                        !doctor['isFavorite'];
                                  });
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 1),
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
                              Text(
                                doctor['location'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500],
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
