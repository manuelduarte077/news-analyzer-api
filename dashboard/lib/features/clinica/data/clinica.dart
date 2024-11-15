import '../clinica_list.dart';

final List<Clinica> clinicas = [
  Clinica(
    nombre: 'Clínica San Pedro',
    ubicacion: 'Calle 1, Ciudad A',
    horarioAtencion: 'Lunes a Viernes de 8:00 a 18:00',
    doctor: [
      Doctor(
        nombre: 'Dr. Juan Pérez',
        especialidad: 'Pediatría',
        telefono: '1234567890',
        email: 'juan@gmail.com',
      ),
    ],
    coordenadas: Coordenadas(latitud: 0.0, longitud: 0.0),
    servicios: [
      Servicio(
        nombre: 'Pediatría',
        descripcion: 'Atención a niños y niñas',
      ),
      Servicio(
        nombre: 'Ginecología',
        descripcion: 'Atención a mujeres',
      ),
      Servicio(
        nombre: 'Medicina General',
        descripcion: 'Atención a todo público',
      ),
    ],
  ),

  ///
  Clinica(
    nombre: 'Clínica San Pedro',
    ubicacion: 'Calle 1, Ciudad A',
    horarioAtencion: 'Lunes a Viernes de 8:00 a 18:00',
    doctor: [
      Doctor(
        nombre: 'Dr. Juan Pérez',
        especialidad: 'Pediatría',
        telefono: '1234567890',
        email: 'juan@gmail.com',
      ),
      Doctor(
        nombre: 'Dr. Juan Pérez',
        especialidad: 'Pediatría',
        telefono: '1234567890',
        email: 'juan@gmail.com',
      ),
      Doctor(
        nombre: 'Dr. Juan Pérez',
        especialidad: 'Pediatría',
        telefono: '1234567890',
        email: 'juan@gmail.com',
      ),
    ],
    coordenadas: Coordenadas(latitud: 0.0, longitud: 0.0),
    servicios: [
      Servicio(
        nombre: 'Pediatría',
        descripcion: 'Atención a niños y niñas',
      ),
    ],
  ),
];
