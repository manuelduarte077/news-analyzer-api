import 'package:flutter/material.dart';

class ClinicaListScreen extends StatelessWidget {
  const ClinicaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Lista de Clínicas', style: TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Agregar Clínica',
        child: const Icon(Icons.add),
      ),
    );
  }
}
