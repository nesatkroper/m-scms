import 'dart:convert';
import 'package:m_scms/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:m_scms/models/subject.dart';
import 'package:m_scms/services/auth_service.dart';

class SubjectService {
  static String get _baseApiUrl => Constant.url;
  final AuthService _authService = AuthService();

  Future<List<Subject>> fetchSubjects() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Authentication token missing.');

    final url = Uri.parse('$_baseApiUrl/api/v1/subjects');

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

        final List<dynamic> subjectsJson = decodedData['subjects'] ?? [];

        return subjectsJson
            .map((json) => Subject.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
