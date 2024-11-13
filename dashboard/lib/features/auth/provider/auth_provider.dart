import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<String> _adminEmails = [
    'admin1@example.com',
    'admin2@example.com',
  ];

  bool get isAuthenticated =>
      _user != null && _adminEmails.contains(_user?.email);

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Iniciar sesión con correo electrónico y contraseña
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_adminEmails.contains(userCredential.user?.email)) {
        _user = userCredential.user;
      } else {
        await signOut();
        throw Exception("Acceso denegado: solo administradores permitidos.");
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthError(e.code);
      log("Error al iniciar sesión: $_errorMessage");
    } catch (e) {
      _errorMessage = "Error al iniciar sesión. Inténtalo de nuevo.";
      log("Error al iniciar sesión: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  String _getFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "El correo electrónico no es válido.";
      case 'user-disabled':
        return "El usuario ha sido deshabilitado.";
      case 'user-not-found':
        return "No se encontró ninguna cuenta con este correo.";
      case 'wrong-password':
        return "La contraseña es incorrecta.";
      default:
        return "Ocurrió un error inesperado. Inténtalo de nuevo.";
    }
  }
}
