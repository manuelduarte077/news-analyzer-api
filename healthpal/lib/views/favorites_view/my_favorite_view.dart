import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/views/favorites_view/my_favorite_doctor_remove_view.dart';
import 'package:healthpal/views/hospitals_view/my_hospital_view.dart';

class MyFavoriteView extends StatefulWidget {
  const MyFavoriteView({super.key});

  @override
  State<MyFavoriteView> createState() => _MyFavoriteViewState();
}

class _MyFavoriteViewState extends State<MyFavoriteView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            splashFactory: NoSplash.splashFactory,
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorWeight: 2.5,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                child: Text(
                  'Doctores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Hospitales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MyFavoriteDoctorRemoveView(),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: MyHospitalView(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
