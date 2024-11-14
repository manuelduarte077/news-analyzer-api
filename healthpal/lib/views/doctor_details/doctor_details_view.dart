import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/views/book_appointment/my_book_appointment_widget_view.dart';
import 'package:healthpal/views/doctor_details/widget/doctor_details_reviews_card_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';
import 'package:readmore/readmore.dart';

class DoctorDetailsView extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailsView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Doctors Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.oxfordBlueColor,
          ),
        ),
        actions: const [
          Icon(
            Icons.favorite_outline,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 133,
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
                              ],
                            ),
                            const Divider(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.5),
                              child: Text(
                                doctor['degree'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
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
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: AppColors.athensGrayColor,
                        ),
                        child: Image.asset(
                            LocalImages.icDoctorDetailsTbPersonIcon),
                      ),
                      const Text(
                        '2,000+',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.riverBedColor,
                        ),
                      ),
                      const Text(
                        'patients',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.paleSkyColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: AppColors.athensGrayColor,
                        ),
                        child:
                            Image.asset(LocalImages.icDoctorDetailsTbMedalIcon),
                      ),
                      const Text(
                        '10+',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.riverBedColor,
                        ),
                      ),
                      const Text(
                        'experience',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.paleSkyColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: AppColors.athensGrayColor,
                        ),
                        child:
                            Image.asset(LocalImages.icDoctorDetailsTbStarIcon),
                      ),
                      const Text(
                        '5',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.riverBedColor,
                        ),
                      ),
                      const Text(
                        'rating',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.paleSkyColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: AppColors.athensGrayColor,
                        ),
                        child: Image.asset(
                            LocalImages.icDoctorDetailsTbMessageReviewIcon),
                      ),
                      const Text(
                        '1,872',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.riverBedColor,
                        ),
                      ),
                      const Text(
                        'reviews',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.paleSkyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About me',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ebonyClayColor,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ReadMoreText(
                    'Dr. David Patel, a dedicated cardiologist, brings a\nwealth of experience to Golden Gate Cardiology\nCenter in Golden Gate, CA.',
                    trimMode: TrimMode.Line,
                    trimLines: 1,
                    colorClickableText: Colors.blueAccent,
                    trimCollapsedText: 'View more',
                    trimExpandedText: 'View less',
                    moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Working Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ebonyClayColor,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Monday-Friday, 08.00 AM-18.00 pm',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.paleSkyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.ebonyClayColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.paleSkyColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const DoctorDetailsReviewsCardView(),
              const SizedBox(
                height: 10,
              ),
              AppButtonView(
                text: 'Book Appointment',
                onTap: () {
                  Navigation.push(
                    context,
                    const MyBookAppointmentWidgetView(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
