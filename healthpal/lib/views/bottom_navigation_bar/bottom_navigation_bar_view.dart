import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/views/booking_view/my_booking_view.dart';
import 'package:healthpal/views/dashboard/dashboard_view.dart';
import 'package:healthpal/views/map/map_view.dart';
import 'package:healthpal/views/profile/profile_edit/profile_edit_view.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    MapView(),
    MyBookingView(),
    ProfileEditView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: AppColors.athensGrayColor,
        backgroundColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Image.asset(
              LocalImages.icHomeOutlinedIcon,
              height: 24,
              width: 24,
              color: AppColors.paleSkyColor,
            ),
            selectedIcon: Image.asset(
              LocalImages.icHomeOnIcon,
              height: 24,
              width: 24,
              color: AppColors.riverBedColor,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Image.asset(
              LocalImages.icLocationOnOutlinedIcon,
              height: 24,
              width: 24,
              color: AppColors.paleSkyColor,
            ),
            selectedIcon: Image.asset(
              LocalImages.icLocationOnIcon,
              height: 24,
              width: 24,
              color: AppColors.riverBedColor,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Image.asset(
              LocalImages.icCalendarOnOutlinedIcon,
              height: 24,
              width: 24,
              color: AppColors.paleSkyColor,
            ),
            selectedIcon: Image.asset(
              LocalImages.icCalendarOnIcon,
              height: 24,
              width: 24,
              color: AppColors.riverBedColor,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Image.asset(
              LocalImages.icPersonOnOutlinedIcon,
              height: 24,
              width: 24,
              color: AppColors.paleSkyColor,
            ),
            selectedIcon: Image.asset(
              LocalImages.icPersonOnIcon,
              height: 24,
              width: 24,
              color: AppColors.riverBedColor,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
