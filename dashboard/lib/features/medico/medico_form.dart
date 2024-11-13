import 'package:flutter/material.dart';

class MedicoFormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _edadController = TextEditingController();
  final _areaController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  MedicoFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextFormField(
              controller: _especialidadController,
              decoration: const InputDecoration(labelText: 'Especialidad'),
            ),
            TextFormField(
              controller: _edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Área del Hospital'),
            ),
            TextFormField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Lógica para crear médico
                }
              },
              child: const Text('Crear Médico'),
            ),
          ],
        ),
      ),
    );
  }
}
