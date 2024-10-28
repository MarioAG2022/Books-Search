// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base para todas las solicitudes
  static const String _baseUrl = 'https://openlibrary.org/search.json?';

  Future<List> fetchBooksByTitle(String query, {int page = 1}) async {
    final url = Uri.parse(
        '${_baseUrl}q=$query&fields=version,author_name,cover_i,edition_count,first_publish_year,key,editions,editions.language,title&limit=30&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['docs'] as List;
    } else {
      throw Exception('Error al obtener libros por título');
    }
  }

  Future<List> fetchBooksByAuthor(String query, {int page = 1}) async {
    final url = Uri.parse(
        '${_baseUrl}author=$query&q&sort=new&fields=version,author_name,cover_i,first_publish_year,key,title&limit=30&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['docs'] as List;
    } else {
      throw Exception('Error al obtener libros por autor');
    }
  }
}
