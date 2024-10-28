import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_books/src/providers/book_providers.dart';

class BookDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final book = Provider.of<BookProvider>(context).book;

    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Libro'),
        ),
        body:
            const Center(child: Text('No se encontraron detalles del libro.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true, // Centra el título
        title: Text(
          book['title'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24, // Aumenta el tamaño del texto
            fontWeight:
                FontWeight.bold, // Opcional: agrega negrita para mayor énfasis
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: book['cover_i'] != null
                    ? Image.network(
                        'https://covers.openlibrary.org/b/id/${book['cover_i']}-L.jpg',
                        height: 400,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text('Imagen no disponible',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          );
                        },
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Imagen no disponible',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Título del libro
            Center(
              child: Text(
                book['title'] ?? 'Sin título',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 4,
              margin:
                  const EdgeInsets.all(16.0), // Espacio alrededor de la tarjeta
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
              ),

              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Espacio interno dentro de la tarjeta
                child: Column(children: [
                  // Autor
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Autor: ${book['author_name'] != null ? book['author_name'][0] : 'Autor desconocido'}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Año de primera publicación
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Año de publicación: ${book['first_publish_year'] ?? 'Desconocido'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Ediciones disponibles
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información de Ediciones',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          const Divider(),
                          Text(
                            'Cantidad de ediciones: ${book['edition_count'] ?? 'No disponible'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Versiones encontradas: ${book['editions']?['numFound'] ?? 'No disponible'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Idioma de la edición: ${book['editions']?['docs']?[0]?['language']?[0] ?? 'No disponible'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Key del libro
                  Row(
                    children: [
                      const Icon(Icons.vpn_key, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Clave de Open Library: ${book['key'] ?? 'Desconocido'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
