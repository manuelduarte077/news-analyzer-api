import 'package:dashboard/features/clinica/clinica_list.dart';
import 'package:flutter/material.dart';

class ClinicaDetailPanel extends StatelessWidget {
  final Clinica clinica;

  const ClinicaDetailPanel({super.key, required this.clinica});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clinica.nombre,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Ubicación: ${clinica.ubicacion}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
