import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/views/booking_view/widget/canceled_widget/canceled_widget_view.dart';
import 'package:healthpal/views/booking_view/widget/completed_widget/completed_widget_view.dart';
import 'package:healthpal/views/booking_view/widget/upcoming_widget/upcoming_widget_view.dart';

class MyBookingView extends StatefulWidget {
  const MyBookingView({super.key});

  @override
  State<MyBookingView> createState() => _MyBookingViewState();
}

class _MyBookingViewState extends State<MyBookingView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: Text(
                'Mis Reservas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TabBar(
            splashFactory: NoSplash.splashFactory,
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorWeight: 2.0,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'En Proceso'),
              Tab(text: 'Completadas'),
              Tab(text: 'Canceladas'),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabController,
                children: const [
                  UpcomingWidgetView(),
                  CompletedWidgetView(),
                  CanceledWidgetView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
