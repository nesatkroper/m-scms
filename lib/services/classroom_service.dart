import 'dart:convert';
import 'package:m_scms/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:m_scms/models/classroom.dart';
import 'package:m_scms/services/auth_service.dart';

class ClassroomService {
  static String get _baseApiUrl => Constant.url;
  final AuthService _authService = AuthService();

  Future<List<Classroom>> fetchClassrooms() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Authentication token missing.');

    final url = Uri.parse('$_baseApiUrl/api/v1/classrooms');

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
        final List<dynamic> classroomsJson = decodedData['data'] ?? [];

        return classroomsJson
            .map((json) => Classroom.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load classrooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
