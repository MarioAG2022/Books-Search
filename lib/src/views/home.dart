import 'package:flutter/material.dart';
import 'package:prueba_books/src/controllers/controller_home.dart';
import '../../src/constants/images.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  late ControllerHome _bookController;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchType = 'title';
  int _selectedIndex = 0;
  int _currentPage = 1; // Página actual para la paginación
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bookController = ControllerHome(context);
    _bookController.initialDb();
    _scrollController.addListener(_onScroll); // Agrega el listener de scroll
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Función para buscar libros con soporte de paginación
  Future<void> _searchBooks(String query, {bool isLoadMore = false}) async {
    if (_isLoading || _isLoadingMore) return;
    if (query.isEmpty) return;

    setState(() {
      if (isLoadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _currentPage = 1;
        _bookController
            .clearBooks(); // Limpia resultados previos para nueva búsqueda
      }
    });

    try {
      if (_searchType == 'author') {
        await _bookController.fetchBooksByAuthor(query, page: _currentPage);
      } else {
        await _bookController.fetchBooksByTitle(query, page: _currentPage);
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _currentPage++; // Incrementa la página para la siguiente llamada
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener libros')),
      );
    }
  }

  // Listener para el scroll infinito
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _searchBooks(_searchController.text, isLoadMore: true);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/'); // Home
        break;
      case 1:
        Navigator.pushNamed(context, 'create_user'); // Registrar Usuario
        break;
      case 2:
        Navigator.pushNamed(context, 'user_details'); // Detalles del Usuario
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true, // Centra el título
          title: const Text(
            'Buscar Libros',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24, // Aumenta el tamaño del texto
              fontWeight: FontWeight
                  .bold, // Opcional: agrega negrita para mayor énfasis
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Material(
                elevation: 4, // Elevación para el contenedor completo
                borderRadius: BorderRadius.circular(
                    12), // Bordes redondeados para el rectángulo
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Espacio interno para separar los elementos del borde
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.book,
                          color: _searchType == 'title'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchType = 'title';
                          });
                        },
                      ),
                      const SizedBox(width: 16.0),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color: _searchType == 'author'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchType = 'author';
                          });
                        },
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide
                                  .none, // Sin borde para un estilo más limpio
                            ),
                            filled: true, // Fondo del TextField
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                _searchBooks(_searchController.text);
                              },
                            ),
                          ),
                          onChanged: (query) {
                            _searchBooks(query);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _bookController.books.length +
                            (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _bookController.books.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final book = _bookController.books[index];
                          final title = book['title'] ?? 'Título desconocido';
                          final author = book['author_name'] != null
                              ? (book['author_name'] is List
                                  ? (book['author_name'] as List).join(', ')
                                  : book['author_name'])
                              : 'Autor desconocido';
                          final year = book['first_publish_year'] != null
                              ? book['first_publish_year'].toString()
                              : 'Año desconocido';

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const CircularProgressIndicator(), // Icono de carga mientras se descarga la imagen
                                    Image.network(
                                      'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; // Muestra la imagen cuando está completamente cargada
                                        } else {
                                          return CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ); // Muestra el indicador mientras carga
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ), // Muestra un icono de error si la imagen no carga
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '$author - $year',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              onTap: () {
                                _bookController.onBookTapped(book);
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black, // Fondo negro para la barra
          selectedItemColor:
              Colors.white, // Color blanco cuando está seleccionado
          unselectedItemColor:
              Colors.grey, // Color gris cuando no está seleccionado
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.grey,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'RegisterUser',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'InfoUser',
            ),
          ],
        ),
      ),
    );
  }
}
