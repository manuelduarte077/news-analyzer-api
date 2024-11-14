import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/views/notifications/widget/notification_list_view.dart';

class MyNotificationsView extends StatefulWidget {
  const MyNotificationsView({super.key});

  @override
  State<MyNotificationsView> createState() => _MyNotificationsViewState();
}

class _MyNotificationsViewState extends State<MyNotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.riverBedColor,
          ),
        ),
      ),
      body: ListView(
        children: [
          NotificationsListView(
            dayName: 'TODAY',
            title: 'Mark All As Read',
            itemCount: 3,
          ),
          NotificationsListView(
            dayName: 'YESTERDAY',
            title: 'Mark All As Read',
            itemCount: 1,
          ),
        ],
      ),
    );
  }
}
