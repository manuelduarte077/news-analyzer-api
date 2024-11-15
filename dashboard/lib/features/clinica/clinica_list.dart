import 'package:dashboard/features/clinica/clinica_detail_panel.dart';
import 'package:flutter/material.dart';

import 'data/clinica.dart';
import 'widgets/add_clinica_form.dart';
import 'widgets/card_clinica.dart';

class Doctor {
  final String nombre;
  final String especialidad;
  final String telefono;
  final String email;

  Doctor({
    required this.nombre,
    required this.especialidad,
    required this.telefono,
    required this.email,
  });
}

class Coordenadas {
  final double latitud;
  final double longitud;

  Coordenadas({
    required this.latitud,
    required this.longitud,
  });
}

class Servicio {
  final String nombre;
  final String descripcion;

  Servicio({
    required this.nombre,
    required this.descripcion,
  });
}

class Clinica {
  final String nombre;
  final String ubicacion;
  final String horarioAtencion;
  final Coordenadas? coordenadas;
  final List<Doctor> doctor;
  final List<Servicio>? servicios;

  Clinica({
    required this.nombre,
    required this.ubicacion,
    required this.doctor,
    this.coordenadas,
    required this.horarioAtencion,
    this.servicios,
  });
}

class ClinicaListScreen extends StatefulWidget {
  const ClinicaListScreen({super.key});

  @override
  State<ClinicaListScreen> createState() => _ClinicaListScreenState();
}

class _ClinicaListScreenState extends State<ClinicaListScreen> {
  Clinica? selectedClinica;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de Clínicas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          selectedClinica != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: FilledButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        isDismissible: false,
                        builder: (context) => const AddClinicaForm(),
                      );
                    },
                    child: const Text(
                      'Agregar Clínica',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: clinicas.length,
              itemBuilder: (context, index) {
                final clinica = clinicas[index];

                return CardClinica(
                  clinica: clinica.nombre,
                  ubicacion: clinica.ubicacion,
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
      floatingActionButton: selectedClinica == null
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  isDismissible: false,
                  builder: (context) => const AddClinicaForm(),
                );
              },
              tooltip: 'Agregar Clínica',
              label: const Text(
                'Agregar Clínica',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          : null,
    );
  }
}
