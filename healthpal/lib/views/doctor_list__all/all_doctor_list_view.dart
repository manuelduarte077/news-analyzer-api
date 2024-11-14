import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/views/doctor_list__all/horizontal_doctor_category_name_list_view/doctor_category_list_view.dart';
import 'package:healthpal/views/doctors_view/my_doctor_view.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class AllDoctorListView extends StatefulWidget {
  const AllDoctorListView({super.key});

  @override
  State<AllDoctorListView> createState() => _AllDoctorListViewState();
}

class _AllDoctorListViewState extends State<AllDoctorListView> {
  TextEditingController addSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Todos los doctores',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.oxfordBlueColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormFieldCustom(
              controller: addSearchController,
              hintText: 'Buscar doctor',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.5),
                child: Icon(
                  Icons.search,
                  color: AppColors.silverColor,
                ),
              ),
            ),

            /// DoctorCategoryListView is a custom widget that displays a list of doctor categories
            const SizedBox(height: 20),
            DoctorCategoryListView(),

            /// MyDoctorView is a custom widget that displays a list of doctors
            const SizedBox(height: 20),
            const Expanded(
              child: MyDoctorView(),
            ),
          ],
        ),
      ),
    );
  }
}
