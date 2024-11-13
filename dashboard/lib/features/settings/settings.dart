import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre del Admin: Admin', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Detalle del Admin o Hospital', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
