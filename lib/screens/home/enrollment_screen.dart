import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  State<EnrollmentPage> createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    // Use the same logic to grab enrollments from the provider
    List<dynamic> enrollments = [];
    if (userData != null && userData['enrollments'] != null) {
      enrollments = userData['enrollments'];
    }

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: kWhiteColor),
        elevation: 0,
        title: const Text(
          'My Enrollment',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhiteColor),
            onPressed: () => authProvider.fetchUserProfile(),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeaderCard(enrollments.length),
              const SizedBox(height: 24),

              // Mapping your API data to the modern cards
              ...enrollments.map((e) => _buildModernEnrollmentCard(e)),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, Color(0xFF6A1B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: kWhiteColor.withValues(alpha: 0.2),
            child: const Icon(Icons.school, color: kWhiteColor, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enrollment Status',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You have $count active courses',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernEnrollmentCard(dynamic data) {
    final offering = data['course_offering'] ?? {};
    final subject = offering['subject'] ?? {};
    final teacher = offering['teacher'] ?? {};
    final classroom = offering['classroom'] ?? {};
    final status = data['status'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header with Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kDarkGreyColor,
                        ),
                      ),
                      Text(
                        subject['code'] ?? '',
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
          ),

          // Detail Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(
                  "Instructor",
                  teacher['name'] ?? 'N/A',
                  Icons.person_outline,
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  "Schedule",
                  "${offering['schedule']} (${offering['time_slot']})",
                  Icons.access_time,
                  Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  "Classroom",
                  "Room ${classroom['room_number'] ?? 'N/A'}",
                  Icons.location_on_outlined,
                  Colors.teal,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  "Course Fee",
                  "\$${offering['fee']}",
                  Icons.payments_outlined,
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kLightGreyColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: kGreyColor),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isStudying = status.toLowerCase() == 'studying';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isStudying ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: kWhiteColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
