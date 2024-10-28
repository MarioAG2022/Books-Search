import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nombre = '';
  String _apellidos = '';
  String _telefono = '';
  String _email = '';
  String _fecha = '';
  int _edad = 0;
  String _genero = '';

  // Getters
  String get nombre => _nombre;
  String get apellidos => _apellidos;
  String get telefono => _telefono;
  String get email => _email;
  String get fecha => _fecha;
  int get edad => _edad;
  String get genero => _genero;

  // Setters
  void setUserData({
    required String nombre,
    required String apellidos,
    required String telefono,
    required String email,
    required String fecha,
    required int edad,
    required String genero,
  }) {
    _nombre = nombre;
    _apellidos = apellidos;
    _telefono = telefono;
    _email = email;
    _fecha = fecha;
    _edad = edad;
    _genero = genero;
    notifyListeners();
  }
}
