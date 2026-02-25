import 'package:m_scms/models/subject.dart';

class Course {
  final int id;
  final String timeSlot;
  final String schedule;
  final String paymentType;
  final double fee;
  final DateTime startTime;
  final DateTime endTime;
  final Subject subject;
  final Teacher teacher;
  final Classroom classroom;

  Course({
    required this.id,
    required this.timeSlot,
    required this.schedule,
    required this.paymentType,
    required this.fee,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.teacher,
    required this.classroom,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // Check if we are parsing from an Enrollment object which nests the course offering
    final Map<String, dynamic> data =
        json.containsKey('course_offering') && json['course_offering'] != null
            ? json['course_offering']
            : json;

    return Course(
      id: data['id'] ?? 0,
      timeSlot: data['time_slot'] ?? 'N/A',
      schedule: data['schedule'] ?? 'N/A',
      paymentType: data['payment_type'] ?? 'N/A',
      fee: double.tryParse(data['fee'].toString()) ?? 0.0,
      // Use join_start and join_end for the actual dates
      startTime:
          DateTime.tryParse(data['join_start']?.toString() ?? '') ??
          DateTime.tryParse(data['start_time']?.toString() ?? '') ??
          DateTime.now(),
      endTime:
          DateTime.tryParse(data['join_end']?.toString() ?? '') ??
          DateTime.tryParse(data['end_time']?.toString() ?? '') ??
          DateTime.now(),

      subject:
          data['subject'] != null
              ? Subject.fromJson(data['subject'])
              : Subject(
                id: 0,
                name: 'Unknown',
                code: '',
                departmentId: 0,
                description: '',
                creditHours: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),

      teacher:
          data['teacher'] != null
              ? Teacher.fromJson(data['teacher'])
              : Teacher(id: 0, name: 'No Teacher', email: ''),

      classroom:
          data['classroom'] != null
              ? Classroom.fromJson(data['classroom'])
              : Classroom(name: 'No Room', roomNumber: 'N/A'),
    );
  }
}

class Teacher {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? qualification;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.qualification,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      qualification: json['qualification'],
    );
  }
}

class Classroom {
  final String name;
  final String roomNumber;

  Classroom({required this.name, required this.roomNumber});

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      name: json['name']?.toString() ?? 'No Room',
      roomNumber: json['room_number']?.toString() ?? 'N/A',
    );
  }
}
