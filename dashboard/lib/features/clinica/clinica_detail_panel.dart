import 'package:dashboard/features/clinica/clinica_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicaDetailPanel extends StatelessWidget {
  final Clinica clinica;

  const ClinicaDetailPanel({super.key, required this.clinica});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(left: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.medical_services,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              clinica.nombre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// Horario de atención
            Text(
              'Horario de atención: ${clinica.horarioAtencion}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),
            Text(
              'Ubicación: ${clinica.ubicacion}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20.h),

            /// Mostrar un mapa con la ubicación de la clínica (Coordenadas)
            Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey[300],
            ),

            /// Mostrar Doctor que atiende en la clínica
            SizedBox(height: 20.h),

            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: clinica.doctor.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final doctor = clinica.doctor[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Doctor
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doctor: ${doctor.nombre}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Email: ${doctor.email}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Teléfono: ${doctor.telefono}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    /// Especialidad
                    Text(
                      'Especialidad: ${doctor.especialidad}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),

            /// Mostrar los servicios que ofrece la clínica
            SizedBox(height: 20.h),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Servicios',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 5.h),

            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: clinica.servicios?.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final servicio = clinica.servicios![index];

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    servicio.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    servicio.descripcion,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Icon(
                    Icons.medical_services,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
