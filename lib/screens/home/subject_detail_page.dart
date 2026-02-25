import 'package:eduwlc/constants/constant.dart';
import 'package:flutter/material.dart';

class SubjectDetailPage extends StatelessWidget {
  final dynamic subject;
  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: kLightGreyColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: kWhiteColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: kPrimaryColor,
            elevation: 0,
            iconTheme: IconThemeData(color: kWhiteColor),
            title: const Text(
              'Subject Details',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor.withOpacity(0.1), kLightGreyColor],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Text(
                          subject.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subject.code,
                          style: TextStyle(
                            fontSize: 16,
                            color: kGreyColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
    
                  Container(
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color.fromARGB(255, 248, 246, 246).withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Credit Hours',
                          '${subject.creditHours} Hours',
                          Icons.timer,
                        ),
                        _buildDetailRow(
                          'Created At',
                          subject.createdAt.toString().split(' ')[0],
                          Icons.calendar_today,
                        ),
                        _buildDetailRow(
                          'Status',
                          'Active',
                          Icons.check_circle_outline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
    
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          subject.description,
                          style: TextStyle(color: kDarkGreyColor, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kLightGreyColor)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kWhiteColor),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(color: kGreyColor, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: kDarkGreyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}