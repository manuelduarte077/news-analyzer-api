import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/medico_provider.dart';
import 'models/medico.dart';

class MedicoFormScreen extends StatefulWidget {
  const MedicoFormScreen({super.key});

  @override
  State<MedicoFormScreen> createState() => _MedicoFormScreenState();
}

class _MedicoFormScreenState extends State<MedicoFormScreen> {
  Medico? _selectedMedico;

  @override
  void initState() {
    super.initState();
    Provider.of<MedicoProvider>(context, listen: false).fetchMedicos();
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1.5, height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildTextFormField(nombreController, 'Nombre',
                            'Por favor, ingresa el nombre'),
                        _buildTextFormField(apellidoController, 'Apellido',
                            'Por favor, ingresa el apellido'),
                        _buildTextFormField(
                            especialidadController,
                            'Especialidad',
                            'Por favor, ingresa la especialidad'),
                        _buildTextFormField(areaController, 'Área',
                            'Por favor, ingresa el área'),
                        _buildTextFormField(usuarioController,
                            'Usuario (Email)', 'Por favor, ingresa el usuario'),
                        _buildTextFormField(passwordController, 'Contraseña',
                            'Por favor, ingresa la contraseña',
                            isPassword: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final medico = Medico(
                              nombre: nombreController.text,
                              apellido: apellidoController.text,
                              especialidad: especialidadController.text,
                              area: areaController.text,
                              usuario: usuarioController.text,
                            );

                            final medicoProvider = Provider.of<MedicoProvider>(
                                context,
                                listen: false);

                            try {
                              await medicoProvider.addMedico(
                                  medico, passwordController.text);
                              if (mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
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

  Widget _buildTextFormField(
      TextEditingController controller, String labelText, String validatorText,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? validatorText : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicos = Provider.of<MedicoProvider>(context).medicos;

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Médicos')),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: medicos.length,
              itemBuilder: (context, index) {
                final medico = medicos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text('${medico.nombre} ${medico.apellido}'),
                    subtitle: Text(medico.especialidad),
                    onTap: () => setState(() => _selectedMedico = medico),
                  ),
                );
              },
            ),
          ),
          if (MediaQuery.of(context).size.width > 800 &&
              _selectedMedico != null)
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
        label: const Text('Agregar Médico'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildMedicoDetail(Medico medico) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${medico.nombre} ${medico.apellido}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Especialidad: ${medico.especialidad}',
                style: const TextStyle(fontSize: 16)),
            Text('Área: ${medico.area}', style: const TextStyle(fontSize: 16)),
            Text('Usuario: ${medico.usuario}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
