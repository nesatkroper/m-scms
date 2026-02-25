import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/models/course.dart';
import 'package:m_scms/services/auth_service.dart';

class CourseService {
  static String get _baseApiUrl => Constant.url;
  final AuthService _authService = AuthService();

  Future<List<Course>> fetchAllCourses() async {
    final token = await _authService.getToken();
    final url = Uri.parse('$_baseApiUrl/api/v1/courses');

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
        final dynamic decodedData = json.decode(response.body);

        final List<dynamic> coursesJson =
            (decodedData is Map)
                ? (decodedData['data'] ?? decodedData['courses'] ?? [])
                : decodedData;

        return coursesJson
            .map((json) => Course.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load school courses: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
