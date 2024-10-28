import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_books/src/providers/book_providers.dart';
import 'package:prueba_books/src/providers/user_providers.dart';
import 'package:prueba_books/src/router/routes.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => BookProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.cyan, // Aquí se define el color de fondo
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Fondo en modo oscuro
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode:
          ThemeMode.system, // Cambia entre claro y oscuro automáticamente
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}
