import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Medico {
  final String nombre;
  final String apellido;
  final String especialidad;
  final String area;
  final String usuario;

  Medico({
    required this.nombre,
    required this.apellido,
    required this.especialidad,
    required this.area,
    required this.usuario,
  });
}

class MedicoFormScreen extends StatefulWidget {
  const MedicoFormScreen({super.key});

  @override
  State<MedicoFormScreen> createState() => _MedicoFormScreenState();
}

class _MedicoFormScreenState extends State<MedicoFormScreen> {
  final List<Medico> _medicos = [];
  Medico? _selectedMedico;

  void _addMedico(Medico medico) {
    setState(() {
      _medicos.add(medico);
    });
  }

  void _showAddMedicoDialog() {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController();
    final apellidoController = TextEditingController();
    final especialidadController = TextEditingController();
    final areaController = TextEditingController();
    final usuarioController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isLargeScreen = MediaQuery.of(context).size.width > 600;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 450 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Agregar Nuevo Médico',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 1.5, height: 30),

                  // Formulario
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildTextFormField(
                          controller: nombreController,
                          labelText: 'Nombre',
                          validatorText:
                              'Por favor, ingresa el nombre del médico.',
                        ),
                        _buildTextFormField(
                          controller: apellidoController,
                          labelText: 'Apellido',
                          validatorText:
                              'Por favor, ingresa el apellido del médico.',
                        ),
                        _buildTextFormField(
                          controller: especialidadController,
                          labelText: 'Especialidad',
                          validatorText: 'Por favor, ingresa la especialidad.',
                        ),
                        _buildTextFormField(
                          controller: areaController,
                          labelText: 'Área',
                          validatorText: 'Por favor, ingresa el área.',
                        ),
                        _buildTextFormField(
                          controller: usuarioController,
                          labelText: 'Usuario',
                          validatorText: 'Por favor, ingresa el usuario.',
                        ),
                        _buildTextFormField(
                          controller: passwordController,
                          labelText: 'Contraseña',
                          isPassword: true,
                          validatorText: 'Por favor, ingresa la contraseña.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botón de agregar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(120, 50),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 50),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final medico = Medico(
                              nombre: nombreController.text,
                              apellido: apellidoController.text,
                              especialidad: especialidadController.text,
                              area: areaController.text,
                              usuario: usuarioController.text,
                            );
                            _addMedico(medico);
                            context.pop();
                          }
                        },
                        child: const Text('Agregar Médico'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Método para crear campos de texto reutilizables
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? validatorText,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Médicos'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _medicos.length,
              itemBuilder: (context, index) {
                final medico = _medicos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text('${medico.nombre} ${medico.apellido}'),
                    subtitle: Text(medico.especialidad),
                    onTap: () {
                      setState(() {
                        _selectedMedico = medico;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          if (isLargeScreen && _selectedMedico != null)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildMedicoDetail(_selectedMedico!),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicoDialog,
        tooltip: 'Agregar Médico',
        label: const Text('Agregar Médico'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildMedicoDetail(Medico medico) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${medico.nombre} ${medico.apellido}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Especialidad: ${medico.especialidad}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Área: ${medico.area}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Usuario: ${medico.usuario}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
