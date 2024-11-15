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

  // Método para convertir un Medico a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'especialidad': especialidad,
      'area': area,
      'usuario': usuario,
    };
  }

  // Constructor para convertir datos de Firestore a un objeto Medico
  factory Medico.fromFirestore(Map<String, dynamic> data) {
    return Medico(
      nombre: data['nombre'],
      apellido: data['apellido'],
      especialidad: data['especialidad'],
      area: data['area'],
      usuario: data['usuario'],
    );
  }
}
