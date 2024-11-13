import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicoListScreen extends StatelessWidget {
  const MedicoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              _buildCountersSection(),
              SizedBox(height: 50.h),
              _buildChartSection(),
              SizedBox(height: 50.h),
              _buildRecentItemsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountersSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCounterCard('Doctores', 125, Colors.blue),
        _buildCounterCard('Pacientes', 300, Colors.green),
        _buildCounterCard('Citas', 80, Colors.orange),
        _buildCounterCard('Clínicas', 12, Colors.purple),
      ],
    );
  }

  Widget _buildCounterCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Sección del gráfico
  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 3.5,
          child: BarChart(
            BarChartData(
              barGroups: [
                _buildBarChartGroupData(0, 125, Colors.blue), // Doctores
                _buildBarChartGroupData(1, 300, Colors.green), // Pacientes
                _buildBarChartGroupData(2, 80, Colors.orange), // Citas
                _buildBarChartGroupData(3, 12, Colors.purple), // Clínicas
              ],
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Doctores');
                        case 1:
                          return const Text('Pacientes');
                        case 2:
                          return const Text('Citas');
                        case 3:
                          return const Text('Clínicas');
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(
                show: true,
              ),
              borderData: FlBorderData(
                show: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarChartGroupData(int x, int y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Sección de ítems recientes
  Widget _buildRecentItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Últimos Registros',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildRecentList('Doctores', [
          'Dr. Juan Pérez',
          'Dra. Ana López',
          'Dr. Carlos Díaz',
          'Dra. María Gómez',
          'Dr. Pablo Núñez'
        ]),
        const SizedBox(height: 10),
        _buildRecentList('Clínicas', [
          'Clínica San Pedro',
          'Clínica Santa María',
          'Clínica del Sol',
          'Clínica Los Ángeles',
          'Clínica Salud Total'
        ]),
        const SizedBox(height: 10),
        _buildRecentList('Pacientes', [
          'Juan Torres',
          'Ana Martínez',
          'Carlos Ramírez',
          'Laura Sánchez',
          'Pedro Hernández'
        ]),
      ],
    );
  }

  Widget _buildRecentList(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        ...items.take(5).map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icono de usuario
                      const Icon(
                        Icons.person_2_outlined,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 20),

                      // Columna principal de detalles
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre del doctor
                            Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Especialidad
                            Text(
                              'Especialidad: Pediatría',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Teléfono y otros detalles
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '1234567890',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Información extra (puedes agregar más detalles aquí si lo deseas)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Detalles',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Más información...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
