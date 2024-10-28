import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_books/src/controllers/base_controller.dart';
import 'package:prueba_books/src/providers/book_providers.dart';
import 'package:prueba_books/src/services/api.dart';
import 'package:sqflite/sqflite.dart';

class ControllerHome extends BaseController {
  ControllerHome(contex) : super(contex);
  List<dynamic> books = [];
  final ApiService _apiService = ApiService();

  void clearBooks() {
    books.clear();
  }

  //En caso de que se requiera que la informacion del usario sea perssitente se peude usar esta funcion pero por motivos de tiempo no deci implementarla
  //En este caso se plateaba usar sqflite
  Future<void> initialDb() async {
    // Obtener la ubicación de la base de datos
    var databasesPath = await getDatabasesPath();
    String path = (databasesPath + 'demo.db');
    // print('Data path: $path');

    // Método para limpiar la lista de libros

    var db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Crear la tabla
      await db.execute(
          'CREATE TABLE usuario (id INTEGER PRIMARY KEY, nombre TEXT, apellidos TEXT, telefono TEXT, email TEXT, fecha TEXT, edad TEXT, genero TEXT)');
    });

    // Insertar algunos registros
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO usuario (nombre, apellidos, telefono, email, fecha, edad, genero) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            'Juan',
            'Pérez',
            '123456789',
            'juan@example.com',
            '2023-01-01',
            '30',
            'Masculino'
          ]);
      print('Inserted record 1: $id1');

      int id2 = await txn.rawInsert(
          'INSERT INTO usuario (nombre, apellidos, telefono, email, fecha, edad, genero) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            'Ana',
            'García',
            '987654321',
            'ana@example.com',
            '2023-02-01',
            '25',
            'Femenino'
          ]);
      // print('Inserted record 2: $id2');
    });

    // Obtener los registros
    List<Map> list = await db.rawQuery('SELECT * FROM usuario');
    // print('Lista: $list');
  }

  // Función para hacer la búsqueda en la API de OpenLibrary
  Future<void> fetchBooksByTitle(String query, {int page = 1}) async {
    try {
      List<dynamic> newBooks =
          await _apiService.fetchBooksByTitle(query, page: page);
      if (page == 1) {
        books = newBooks; // Nueva búsqueda, reemplaza la lista
      } else {
        books.addAll(newBooks); // Agrega los libros de la nueva página
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchBooksByAuthor(String query, {int page = 1}) async {
    try {
      List<dynamic> newBooks =
          await _apiService.fetchBooksByAuthor(query, page: page);
      if (page == 1) {
        books = newBooks; // Nueva búsqueda, reemplaza la lista
      } else {
        books.addAll(newBooks); // Agrega los libros de la nueva página
      }
    } catch (e) {
      print(e);
    }
  }

  void onBookTapped(Map<String, dynamic> book) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider.setBook(book); // Establecer el libro en el provider
    Navigator.pushNamed(
        context, 'book_details'); // Navegar a los detalles del libro
  }
}
