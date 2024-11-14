import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/views/map/hospital_details_widget/hospital_details_view.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  TextEditingController addSearchController = TextEditingController();
  // GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GoogleMap(
          //   onMapCreated: (controller) {
          //     mapController = controller;
          //   },
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(-33.8688, 151.2093),
          //     zoom: 10,
          //   ),
          // ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: TextFormFieldCustom(
              fillColor: AppColors.whiteColor,
              controller: addSearchController,
              hintText: 'Buscar Hospital',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.5),
                child: Icon(
                  Icons.search,
                  color: AppColors.silverColor,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: const HospitalDetailsView(),
            ),
          ),
        ],
      ),
    );
  }
}
