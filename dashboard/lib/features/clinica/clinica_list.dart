import 'package:dashboard/features/clinica/clinica_detail_panel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Clinica {
  final String nombre;
  final String ubicacion;

  Clinica({required this.nombre, required this.ubicacion});
}

class ClinicaListScreen extends StatefulWidget {
  const ClinicaListScreen({super.key});

  @override
  State<ClinicaListScreen> createState() => _ClinicaListScreenState();
}

class _ClinicaListScreenState extends State<ClinicaListScreen> {
  final List<Clinica> clinicas = [
    Clinica(nombre: 'Clínica San Pedro', ubicacion: 'Calle 1, Ciudad A'),
    Clinica(nombre: 'Clínica Santa María', ubicacion: 'Avenida 5, Ciudad B'),
    Clinica(nombre: 'Clínica del Sol', ubicacion: 'Calle 3, Ciudad C'),
  ];

  Clinica? selectedClinica;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clínicas'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: clinicas.length,
              itemBuilder: (context, index) {
                final clinica = clinicas[index];

                return ListTile(
                  title: Text(clinica.nombre),
                  subtitle: Text(clinica.ubicacion),
                  selected: selectedClinica == clinica,
                  onTap: () {
                    setState(() {
                      selectedClinica = clinica;
                    });
                  },
                );
              },
            ),
          ),
          if (!isMobile && selectedClinica != null)
            Expanded(
              flex: 3,
              child: ClinicaDetailPanel(clinica: selectedClinica!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Agregar Clínica',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Ubicación'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Agregar Clínica'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Agregar Clínica',
        child: const Icon(Icons.add),
      ),
    );
  }
}
