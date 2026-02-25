import 'package:eduwlc/models/subject.dart';

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
    return Course(
      id: json['id'] ?? 0,
      timeSlot: json['time_slot'] ?? 'N/A',
      schedule: json['schedule'] ?? 'N/A',
      paymentType: json['payment_type'] ?? 'N/A',
      fee: double.tryParse(json['fee'].toString()) ?? 0.0,
      startTime: DateTime.parse(
        json['start_time'] ?? DateTime.now().toIso8601String(),
      ),
      endTime: DateTime.parse(
        json['end_time'] ?? DateTime.now().toIso8601String(),
      ),

      subject:
          json['subject'] != null
              ? Subject.fromJson(json['subject'])
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
          json['teacher'] != null
              ? Teacher.fromJson(json['teacher'])
              : Teacher(id: 0, name: 'No Teacher', email: ''),

      classroom:
          json['classroom'] != null
              ? Classroom.fromJson(json['classroom'])
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
    return Classroom(name: json['name'], roomNumber: json['room_number']);
  }
}
