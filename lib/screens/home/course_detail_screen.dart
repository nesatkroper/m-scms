import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/models/course.dart';
import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: kWhiteColor),
        elevation: 0,
        title: const Text("Course Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: kPrimaryColor,
              child: Column(
                children: [
                  Text(
                    course.subject.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTag(
                    course.subject.code,
                    kWhiteColor.withValues(alpha: 0.2),
                    kWhiteColor,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSectionCard("Instructor", [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: kPrimaryColor.withValues(alpha: 0.1),
                        child: Text(
                          course.teacher.name[0],
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      title: Text(
                        course.teacher.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        course.teacher.qualification ?? "Senior Instructor",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildSectionCard("Schedule & Location", [
                    _buildInfoRow(
                      "Days",
                      course.schedule,
                      Icons.calendar_month,
                    ),
                    _buildInfoRow(
                      "Time Slot",
                      course.timeSlot,
                      Icons.access_time,
                    ),
                    _buildInfoRow(
                      "Room",
                      "${course.classroom.name} (${course.classroom.roomNumber})",
                      Icons.room,
                    ),
                    _buildInfoRow(
                      "Fee",
                      "\$${course.fee} / ${course.paymentType}",
                      Icons.payments,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kPrimaryColor),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: kGreyColor)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
