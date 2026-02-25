import 'dart:convert';
import 'dart:developer' as developer;
import 'package:m_scms/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';

  static String get _baseApiUrl => Appurl.url;

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseApiUrl/api/v1/$path');
  }

  Future<bool> login(String username, String password) async {
    final url = _buildUrl('login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username,
          'password': password,
          'device_name': 'mobile',
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['token'] ?? body['access_token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          developer.log('Login successful. Token stored.', name: 'AuthService');
          return true;
        } else {
          developer.log(
            'Login failed: Token not found in response. Body: ${response.body}',
            name: 'AuthService',
          );
          return false;
        }
      } else {
        developer.log(
          'Login API Error (${response.statusCode}): ${response.body}',
          name: 'AuthService',
        );
        return false;
      }
    } catch (e) {
      developer.log(
        'Network Error during login: $e',
        name: 'AuthService',
        error: e,
      );
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> fetchData(String path) async {
    final token = await getToken();
    if (token == null) {
      developer.log(
        "No authentication token found. Cannot fetch data.",
        name: 'AuthService',
      );
      return null;
    }

    final url = _buildUrl(path);

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
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        developer.log(
          'Authorization Failed for $path: Token might be expired or invalid. Status: ${response.statusCode}',
          name: 'AuthService',
        );
        return null;
      } else {
        developer.log(
          'API Fetch Error (${response.statusCode}) for path $path: ${response.body}',
          name: 'AuthService',
        );
        return null;
      }
    } catch (e) {
      developer.log(
        'Network Error during data fetch for $path: $e',
        name: 'AuthService',
        error: e,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    return await fetchData('profile');
  }

  Future<bool> logout() async {
    final token = await getToken();
    final url = _buildUrl('logout');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);

    if (token == null) {
      developer.log("Local token already cleared.", name: 'AuthService');
      return true;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        developer.log('Server logout successful.', name: 'AuthService');
      } else {
        developer.log(
          'Logout failed on server side (${response.statusCode}). Local token cleared.',
          name: 'AuthService',
        );
      }
      return true;
    } catch (e) {
      developer.log(
        'Network Error during logout. Local token cleared: $e',
        name: 'AuthService',
        error: e,
      );
      return true;
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await getToken();
    if (token == null) {
      return {'status': false, 'message': 'Authentication required'};
    }

    final url = _buildUrl('change_password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      developer.log(
        'Error during changePassword: $e',
        name: 'AuthService',
        error: e,
      );
      return {'status': false, 'message': 'Network connection error'};
    }
  }

  Future<Map<String, dynamic>> sendRequestReview({
    required int teacherId,
    required String title,
    required String body,
  }) async {
    final token = await getToken();
    final url = _buildUrl('send_notification');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': teacherId, 'title': title, 'body': body}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'status': false, 'message': 'Connection error: $e'};
    }
  }
}
