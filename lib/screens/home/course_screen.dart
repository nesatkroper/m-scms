import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/models/course.dart';
import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/screens/home/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchSchoolCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courses = authProvider.allCourses;

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: kWhiteColor),
        elevation: 0,
        title: Text(
          'School Course Catalog',
          style: TextStyle(
            color: kWhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: kWhiteColor),
            onPressed: () => authProvider.fetchSchoolCourses(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor.withValues(alpha: 0.1), kLightGreyColor],
          ),
        ),
        child:
            authProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: () => authProvider.fetchSchoolCourses(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildHeaderCard(courses.length),
                        const SizedBox(height: 24),

                        courses.isEmpty
                            ? const Center(
                              child: Text("No courses found in database"),
                            )
                            : Column(
                              children:
                                  courses
                                      .map(
                                        (course) =>
                                            _buildCourseCard(context, course),
                                      )
                                      .toList(),
                            ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildHeaderCard(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kSecondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.hub, color: kWhiteColor, size: 40),
          const SizedBox(height: 12),
          Text(
            'Global Course List',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Currently showing $count available courses',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.subject.name,
                        style: TextStyle(
                          color: kDarkGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        course.subject.code,
                        style: TextStyle(color: kGreyColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${course.fee}",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(course: course),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRowInfo(Icons.person, "Teacher", course.teacher.name),
                  const SizedBox(height: 8),
                  _buildRowInfo(
                    Icons.room,
                    "Classroom",
                    course.classroom.roomNumber,
                  ),
                  const SizedBox(height: 8),
                  _buildRowInfo(
                    Icons.event,
                    "Start Date",
                    DateFormat('dd MMM yyyy').format(course.startTime),
                  ),
                  const SizedBox(height: 8),
                  _buildRowInfo(
                    Icons.event_available,
                    "End Date",
                    DateFormat('dd MMM yyyy').format(course.endTime),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTag(course.timeSlot.toUpperCase(), Colors.orange),
                      _buildTag(course.schedule.toUpperCase(), Colors.blue),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: kGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kPrimaryColor),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(color: kGreyColor, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: kDarkGreyColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
