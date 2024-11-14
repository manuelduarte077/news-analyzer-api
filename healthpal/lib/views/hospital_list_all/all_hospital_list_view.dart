import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/views/hospitals_view/my_hospital_view.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class AllHospitalListView extends StatefulWidget {
  const AllHospitalListView({super.key});

  @override
  State<AllHospitalListView> createState() => _AllHospitalListViewState();
}

class _AllHospitalListViewState extends State<AllHospitalListView> {
  TextEditingController addSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text(
              'All Hospitals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.oxfordBlueColor,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TextFormFieldCustom(
                    controller: addSearchController,
                    hintText: 'Search Hospitals',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.5),
                      child: Icon(
                        Icons.search,
                        color: AppColors.silverColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 650,
                    child: MyHospitalView(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
