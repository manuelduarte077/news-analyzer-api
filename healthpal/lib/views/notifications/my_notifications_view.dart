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
        surfaceTintColor: AppColors.whiteColor,
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        title: const Text(
          'Notificaciones',
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
            dayName: 'HOY',
            title: 'Marcar Todo Como Leído',
            itemCount: 3,
          ),
          NotificationsListView(
            dayName: 'AYER',
            title: 'Marcar Todo Como Leído',
            itemCount: 1,
          ),
        ],
      ),
    );
  }
}
