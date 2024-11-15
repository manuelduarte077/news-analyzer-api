import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/features/map/hospital_details_widget/hospital_details_view.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  TextEditingController addSearchController = TextEditingController();
  GoogleMapController? mapController;

  List<Map<String, dynamic>> filteredCenters =
      HospitalDetailsView.medicalCenters;

  void _moveCameraToLocation(double latitude, double longitude) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude, longitude),
        ),
      );
    }
  }

  void _filterCenters(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCenters = HospitalDetailsView.medicalCenters;
      } else {
        filteredCenters = HospitalDetailsView.medicalCenters.where((center) {
          final name = center['name'].toLowerCase();
          final address = center['address'].toLowerCase();
          return name.contains(query.toLowerCase()) ||
              address.contains(query.toLowerCase());
        }).toList();
      }
    });

    if (filteredCenters.isNotEmpty) {
      final firstCenter = filteredCenters.first;
      _moveCameraToLocation(firstCenter['latitude'], firstCenter['longitude']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(14.0384, -83.3888),
              zoom: 10,
            ),
            myLocationButtonEnabled: false,
            markers: {
              for (var center in HospitalDetailsView.medicalCenters)
                Marker(
                  markerId: MarkerId(center['name']),
                  position: LatLng(center['latitude'], center['longitude']),
                  infoWindow: InfoWindow(
                    title: center['name'],
                    snippet: center['address'],
                  ),
                ),
            },
          ),
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
              callBackOnChange: _filterCenters,
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
              child: HospitalDetailsView(
                onCardTap: (latitude, longitude) {
                  _moveCameraToLocation(latitude, longitude);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
