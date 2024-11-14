import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/medico.dart';

class MedicoProvider with ChangeNotifier {
  final List<Medico> _medicos = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Medico> get medicos => _medicos;

  Future<void> fetchMedicos() async {
    try {
      final snapshot = await _firestore.collection('medicos').get();
      _medicos.clear();

      for (var doc in snapshot.docs) {
        _medicos.add(Medico.fromFirestore(doc.data()));
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }

  // Llamada a la Firebase Function para crear el médico
  Future<void> addMedico(Medico medico, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No hay ningún administrador autenticado.');
      }
      log('Sesión activa de administrador: ${user.email}');

      // Llama a la Firebase Function para crear el usuario del médico
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createMedicoUser');

      final response = await callable.call(<String, dynamic>{
        'email': medico.usuario,
        'password': password,
        'nombre': medico.nombre,
        'apellido': medico.apellido,
        'especialidad': medico.especialidad,
        'area': medico.area,
      });

      final resultData = response.data;
      log('Médico creado con UID: ${resultData['uid']}');

      // Agregar el médico a la lista local para que la UI se actualice
      _medicos.add(medico);
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          throw Exception('Este correo ya está en uso.');
        case 'invalid-email':
          throw Exception('La dirección de correo electrónico no es válida.');
        case 'weak-password':
          throw Exception('La contraseña es muy débil.');
        default:
          throw Exception('Error de autenticación: ${error.message}');
      }
    } else {
      throw Exception('Ocurrió un error inesperado: $error');
    }
  }
}
