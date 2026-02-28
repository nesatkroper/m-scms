import 'package:m_scms/services/course_service.dart';
import 'package:flutter/foundation.dart';
import 'package:m_scms/services/auth_service.dart';
import 'package:m_scms/services/subject_service.dart';
import 'package:m_scms/models/subject.dart';
import 'package:m_scms/models/course.dart';
import 'package:m_scms/models/book.dart';
import 'package:m_scms/models/classroom.dart';
import 'package:m_scms/services/book_service.dart';
import 'package:m_scms/services/classroom_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  List<Subject> _subjects = [];
  List<Course> _myCourses = [];
  List<Classroom> _classrooms = [];

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  List<Subject> get subjects => _subjects;
  List<Course> get myCourses => _myCourses;
  List<Classroom> get classrooms => _classrooms;

  final AuthService _authService = AuthService();
  final SubjectService _subjectService = SubjectService();
  final CourseService _courseService = CourseService();
  final BookService _bookService = BookService();
  final ClassroomService _classroomService = ClassroomService();

  List<Course> _allCourses = [];
  List<Course> get allCourses => _allCourses;

  List<Book> _books = [];
  List<Book> get books => _books;

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

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _books = await _bookService.fetchBooks();
    } catch (e) {
      debugPrint("Books fetch error: $e");
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
          _myCourses =
              enrollmentList
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

  Future<void> fetchClassrooms() async {
    _isLoading = true;
    notifyListeners();
    try {
      _classrooms = await _classroomService.fetchClassrooms();
    } catch (e) {
      debugPrint("Classroom fetch error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
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
