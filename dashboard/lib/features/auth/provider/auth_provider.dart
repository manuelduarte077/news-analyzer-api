import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  User? get user => _user;

  final List<String> adminEmails = [
    'admin1@example.com',
    'admin2@example.com',
  ];

  bool get isAuthenticated =>
      _user != null && adminEmails.contains(_user?.email);

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log("Error al iniciar sesión: $e");
      throw Exception("Error al iniciar sesión");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
