import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/models/book.dart';
import 'package:m_scms/services/auth_service.dart';

class BookService {
  static String get _baseApiUrl => Constant.url;
  final AuthService _authService = AuthService();

  Future<List<Book>> fetchBooks() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Authentication token missing.');

    final url = Uri.parse('$_baseApiUrl/api/v1/books');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        if (decodedData['status'] == true) {
          final List<dynamic> booksJson = decodedData['books'] ?? [];
          return booksJson.map((json) => Book.fromJson(json)).toList();
        } else {
          throw Exception(decodedData['message'] ?? 'Failed to load books');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<Book?> fetchBookByName(String name) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Authentication token missing.');

    final url = Uri.parse('$_baseApiUrl/api/v1/books/$name');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        if (decodedData['status'] == true && decodedData['book'] != null) {
          return Book.fromJson(decodedData['book']);
        } else {
          throw Exception(decodedData['message'] ?? 'Failed to load book');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
