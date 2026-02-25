class Enrollment {
  final String subjectName;
  final String subjectCode;
  final String teacherName;
  final String roomName;
  final String schedule;
  final String status;
  final String fee;
  final String timeSlot;

  Enrollment({
    required this.subjectName,
    required this.subjectCode,
    required this.teacherName,
    required this.roomName,
    required this.schedule,
    required this.status,
    required this.fee,
    required this.timeSlot,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    final offering = json['course_offering'];
    final subject = offering['subject'];
    final teacher = offering['teacher'];
    final classroom = offering['classroom'];

    return Enrollment(
      subjectName: subject['name'] ?? '',
      subjectCode: subject['code'] ?? '',
      teacherName: teacher['name'] ?? 'No Teacher',
      roomName: "${classroom['name']} (${classroom['room_number']})",
      schedule: offering['schedule'] ?? '',
      status: json['status'] ?? '',
      fee: offering['fee'] ?? '0.00',
      timeSlot: offering['time_slot'] ?? '',
    );
  }
}
