import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../clinica_list.dart';
import 'filled_button_widget.dart';

class AddClinicaForm extends StatefulWidget {
  const AddClinicaForm({super.key});

  @override
  State<AddClinicaForm> createState() => _AddClinicaFormState();
}

class _AddClinicaFormState extends State<AddClinicaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _horarioController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  final List<Doctor> _doctores = [];
  final List<Servicio> _servicios = [];

  final _doctorNombreController = TextEditingController();
  final _doctorEspecialidadController = TextEditingController();
  final _doctorTelefonoController = TextEditingController();
  final _doctorEmailController = TextEditingController();

  final _servicioNombreController = TextEditingController();
  final _servicioDescripcionController = TextEditingController();

  void _addDoctor() {
    if (_doctorNombreController.text.isNotEmpty &&
        _doctorEspecialidadController.text.isNotEmpty &&
        _doctorTelefonoController.text.isNotEmpty &&
        _doctorEmailController.text.isNotEmpty) {
      setState(() {
        _doctores.add(Doctor(
          nombre: _doctorNombreController.text,
          especialidad: _doctorEspecialidadController.text,
          telefono: _doctorTelefonoController.text,
          email: _doctorEmailController.text,
        ));
      });
      _doctorNombreController.clear();
      _doctorEspecialidadController.clear();
      _doctorTelefonoController.clear();
      _doctorEmailController.clear();
    }
  }

  void _addServicio() {
    if (_servicioNombreController.text.isNotEmpty &&
        _servicioDescripcionController.text.isNotEmpty) {
      setState(() {
        _servicios.add(Servicio(
          nombre: _servicioNombreController.text,
          descripcion: _servicioDescripcionController.text,
        ));
      });
      _servicioNombreController.clear();
      _servicioDescripcionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Agregar Clínica',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la clínica',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _horarioController,
                decoration: InputDecoration(
                  labelText: 'Horario de Atención',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Coordenadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudController,
                      decoration: InputDecoration(
                        labelText: 'Latitud',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudController,
                      decoration: InputDecoration(
                        labelText: 'Longitud',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Doctores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ..._doctores.map(
                (doctor) => ListTile(
                  title: Text(doctor.nombre),
                  subtitle: Text(doctor.especialidad),
                ),
              ),
              TextFormField(
                controller: _doctorNombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del doctor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _doctorEspecialidadController,
                decoration: InputDecoration(
                  labelText: 'Especialidad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _doctorTelefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _doctorEmailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              FilledButtonWidget(
                onPressed: _addDoctor,
                label: 'Agregar Doctor',
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Servicios',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ..._servicios.map((servicio) => ListTile(
                    title: Text(servicio.nombre),
                    subtitle: Text(servicio.descripcion),
                  )),
              TextFormField(
                controller: _servicioNombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del servicio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _servicioDescripcionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButtonWidget(
                onPressed: _addServicio,
                label: 'Agregar Servicio',
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButtonWidget(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.pop();
                      }
                    },
                    label: 'Guardar Clínica',
                  ),
                  FilledButtonWidget(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.pop();
                      }
                    },
                    label: 'Cancelar',
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
