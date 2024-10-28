import 'package:flutter/material.dart';
import 'package:prueba_books/src/views/book_details.dart';
import 'package:prueba_books/src/views/create_user.dart';
import 'package:prueba_books/src/views/home.dart';
import 'package:prueba_books/src/views/user_details.dart';

class Routes {
  static const initialRoute = '/';
  //static const initialRoute = 'registro';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const Home(),
    'book_details': (context) => BookDetailsPage(),
    'create_user': (context) => CreateUserScreen(),
    'user_details': (context) => UserDetailsScreen(),
  };

  static onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const Home(),
    );
  }
}
