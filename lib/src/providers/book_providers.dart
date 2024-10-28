import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  Map<String, dynamic>? _book; // Aquí almacenamos el libro

  Map<String, dynamic>? get book => _book; // Getter para acceder al libro

  // Método para establecer el libro y notificar a los oyentes
  void setBook(Map<String, dynamic> book) {
    _book = book;
    notifyListeners(); // Notificar a los consumidores que el libro ha cambiado
  }
}
