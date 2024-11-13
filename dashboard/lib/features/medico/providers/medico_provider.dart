import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/medico.dart';

class MedicoProvider with ChangeNotifier {
  final List<Medico> _medicos = [];

  List<Medico> get medicos => _medicos;

  Future<void> fetchMedicos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('medicos').get();
    _medicos.clear();
    for (var doc in snapshot.docs) {
      _medicos.add(Medico.fromFirestore(doc.data()));
    }
    notifyListeners();
  }

  Future<void> addMedico(Medico medico, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: medico.usuario,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('medicos')
          .doc(userCredential.user!.uid)
          .set(medico.toMap());

      _medicos.add(medico);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al crear el médico: $e');
    }
  }
}
