import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<void> addMedico(Medico medico, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: medico.usuario,
        password: password,
      );

      await _firestore
          .collection('medicos')
          .doc(userCredential.user?.uid)
          .set(medico.toMap());

      _medicos.add(medico);
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  // Handle errors more precisely and log them
  void _handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          throw Exception('This email is already in use.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'weak-password':
          throw Exception('The password is too weak.');
        default:
          throw Exception('Authentication error: ${error.message}');
      }
    } else {
      throw Exception('An unexpected error occurred: $error');
    }
  }
}
