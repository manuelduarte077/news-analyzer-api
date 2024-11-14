import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/views/doctor_list__all/all_doctor_list_view.dart';
import 'package:healthpal/views/hospital_list_all/all_hospital_list_view.dart';
import 'package:healthpal/views/notifications/my_notifications_view.dart';
import 'package:healthpal/widgets/app_banner/app_banner_view.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';
import 'widget/categories_widget/categories_widget_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  TextEditingController addSearchController = TextEditingController();
  final List<Map<String, dynamic>> medicalCenters = [
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Co. San Miguel',
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Centro de Cardiología Dorado',
    },
    {
      'image': LocalImages.icNearMedicalLogo,
      'name': 'Clínica de Salud Integral',
    },
    // Add more centers here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0) +
            const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ubicación',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.silverColor,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 16,
                          ),
                          Text(
                            'Bilwi, Puerto Cabezas',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          Navigation.push(
                            context,
                            const MyNotificationsView(),
                          );
                        },
                      ),
                      Positioned(
                        right: 14,
                        top: 14,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormFieldCustom(
                controller: addSearchController,
                hintText: 'Buscar Doctor',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12.5),
                  child: Icon(
                    Icons.search,
                    color: AppColors.silverColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const AppBannerView(),

              /// Categories
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigation.push(
                        context,
                        const AllDoctorListView(),
                      );
                    },
                    child: const Text(
                      'Ver Todo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.silverColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              /// Categories Grid
              GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                childAspectRatio: 0.8,
                children: const [
                  CategoriesWidgetView(
                    image: LocalImages.icDentistryLogo,
                    text: 'Odontología',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icCardiologyLogo,
                    text: 'Cardiología',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icPulmonoLogo,
                    text: 'Pulmón',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icGeneralLogo,
                    text: 'General',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icNeurologyLogo,
                    text: 'Neurología',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icGastroenLogo,
                    text: 'Gastrointestinal',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icLaboratoLogo,
                    text: 'Laboratorio',
                  ),
                  CategoriesWidgetView(
                    image: LocalImages.icVaccinatLogo,
                    text: 'Vacuna',
                  ),
                ],
              ),

              /// Nearby Medical Centers
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Centros Médicos Cercanos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigation.push(
                        context,
                        const AllHospitalListView(),
                      );
                    },
                    child: Text(
                      'Ver Todo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.silverColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medicalCenters.length,
                  itemBuilder: (context, index) {
                    final center = medicalCenters[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            center['image'],
                            height: 120,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 2.5),
                            child: Text(
                              center['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
