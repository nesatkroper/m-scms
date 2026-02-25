import 'package:m_scms/services/course_service.dart';
import 'package:flutter/foundation.dart';
import 'package:m_scms/services/auth_service.dart';
import 'package:m_scms/services/subject_service.dart';
import 'package:m_scms/models/subject.dart';
import 'package:m_scms/models/course.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  List<Subject> _subjects = [];
  List<Course> _myCourses = [];

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  List<Subject> get subjects => _subjects;
  List<Course> get myCourses => _myCourses;

  final AuthService _authService = AuthService();
  final SubjectService _subjectService = SubjectService();
  final CourseService _courseService = CourseService();

  List<Course> _allCourses = [];
  List<Course> get allCourses => _allCourses;

  Future<void> fetchSchoolCourses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allCourses = await _courseService.fetchAllCourses();
    } catch (e) {
      debugPrint("All Courses fetch error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(username, password);

    if (result) {
      _isAuthenticated = true;
      await Future.wait([fetchUserProfile(), fetchSubjects()]);
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> fetchUserProfile() async {
    try {
      final data = await _authService.getProfile();
      if (data != null) {
        _userData = data['user'] ?? data;

        if (_userData!.containsKey('enrollments') &&
            _userData!['enrollments'] != null) {
          final List<dynamic> enrollmentList = _userData!['enrollments'];
          _myCourses = enrollmentList
              .where((e) => e != null)
              .map((e) => Course.fromJson(e))
              .toList();
        } else {
          _myCourses = [];
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Profile fetch error: $e");
    }
  }

  Future<void> fetchSubjects() async {
    try {
      final data = await _subjectService.fetchSubjects();
      _subjects = data;
      notifyListeners();
    } catch (e) {
      debugPrint("Subject fetch error: $e");
    }
  }

  Future<void> checkAuthenticationStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = await _authService.getToken();
    if (token != null) {
      _isAuthenticated = true;
      await Future.wait([fetchUserProfile(), fetchSubjects()]);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> init() async {
    await checkAuthenticationStatus();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _userData = null;
    _subjects = [];
    _myCourses = [];
    notifyListeners();
  }
}
