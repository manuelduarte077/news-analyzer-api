import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.medical_services,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nombre del Admin: Admin',
                style: TextStyle(fontSize: 18),
              ),

              /// Hospital o Clínica al que pertenece
              const SizedBox(height: 10),
              const Text(
                'Hospital: Nuevo Amanecer',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Ubicación
              SizedBox(height: 80.h),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubicación: Managua, Nicaragua',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// Email
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: admin@gmail.com',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Teléfono: 8888-8888',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),

              /// Mostrar 5 últimos registros de pacientes
              SizedBox(height: 40.h),
              const Text(
                'Últimos registros de pacientes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nombre del paciente',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Edad: 25 años',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Fecha de registro: 12/12/2021',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// Estado de la cita
                          const Text(
                            'Estado: Pendiente',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
