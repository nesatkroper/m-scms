import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/providers/auth_provider.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    List<SubjectScore> dynamicScores = [];
    if (userData != null && userData['enrollments'] != null) {
      final List<dynamic> enrollmentList = userData['enrollments'];
      dynamicScores = enrollmentList
          .map((e) => SubjectScore.fromEnrollment(e as Map<String, dynamic>))
          .toList();
    }

    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: const Text(
          'Academic Report',
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
              _buildHeaderCard(),
              const SizedBox(height: 24),

              ...dynamicScores.map((score) => _buildModernSubjectCard(score)),

              const SizedBox(height: 16),
              _buildTotalGPAHeader(dynamicScores),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
            child: Icon(Icons.auto_graph, color: kWhiteColor, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Performance Overview',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your detailed academic tracking',
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSubjectCard(SubjectScore score) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kWhiteColor),
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
                        score.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kDarkGreyColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Academic Year 2025-2026",
                        style: TextStyle(color: kGreyColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildGradeBadge(score.grade),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildScoreTile(
                        "Attendance",
                        score.attendance,
                        Icons.calendar_month,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildScoreTile(
                        "Listening",
                        score.listening,
                        Icons.headset,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildScoreTile(
                        "Writing",
                        score.writing,
                        Icons.edit_note,
                        Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildScoreTile(
                        "Reading",
                        score.reading,
                        Icons.menu_book,
                        Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildScoreTile(
                        "Speaking",
                        score.speaking,
                        Icons.record_voice_over,
                        Colors.pink,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildScoreTile(
                        "Midterm",
                        score.midterm,
                        Icons.quiz,
                        Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildScoreTile(
                  "Final Exam",
                  score.finalScore,
                  Icons.assignment_turned_in,
                  Colors.green,
                  isWide: true,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(thickness: 1, height: 1),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL AGGREGATE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kGreyColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "${score.total}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (double.tryParse(score.total) ?? 0) / 100,
                    minHeight: 8,
                    backgroundColor: kPrimaryColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreTile(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isWide = false,
  }) {
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
                  style: const TextStyle(
                    fontSize: 11,
                    color: kGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
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

  Widget _buildGradeBadge(String grade) {
    Color color = _getGradeColor(grade);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        grade,
        style: const TextStyle(
          color: kWhiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTotalGPAHeader(List<SubjectScore> scores) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kDarkGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 30),
          const SizedBox(width: 15),
          Column(
            children: [
              const Text(
                "AVERAGE TOTAL SCORE",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              Text(
                "${_calculateAverage(scores)}%",
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateAverage(List<SubjectScore> scores) {
    if (scores.isEmpty) return "0.0";
    double total = scores.fold(
      0,
      (sum, item) => sum + (double.tryParse(item.total) ?? 0),
    );
    return (total / scores.length).toStringAsFixed(1);
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B+':
        return Colors.blue;
      case 'B':
        return Colors.orange;
      case 'C+':
        return Colors.amber;
      case 'C':
        return Colors.deepOrange;
      default:
        return kGreyColor;
    }
  }
}

class SubjectScore {
  final String name;
  final String attendance;
  final String listening;
  final String writing;
  final String reading;
  final String speaking;
  final String midterm;
  final String finalScore;
  final String total;
  final String grade;

  SubjectScore({
    required this.name,
    required this.attendance,
    required this.listening,
    required this.writing,
    required this.reading,
    required this.speaking,
    required this.midterm,
    required this.finalScore,
    required this.total,
    required this.grade,
  });

  factory SubjectScore.fromEnrollment(Map<String, dynamic> json) {
    String f(dynamic v) => (v == null || v == "null") ? "0" : v.toString();

    double att = double.tryParse(f(json['attendance_grade'])) ?? 0;
    double lis = double.tryParse(f(json['listening_grade'])) ?? 0;
    double wri = double.tryParse(f(json['writing_grade'])) ?? 0;
    double rea = double.tryParse(f(json['reading_grade'])) ?? 0;
    double spe = double.tryParse(f(json['speaking_grade'])) ?? 0;
    double mid = double.tryParse(f(json['midterm_grade'])) ?? 0;
    double fin = double.tryParse(f(json['final_grade'])) ?? 0;

    double totalSum = att + lis + wri + rea + spe + mid + fin;

    return SubjectScore(
      name: json['course_offering']?['subject']?['name'] ?? "Unknown",
      attendance: f(json['attendance_grade']),
      listening: f(json['listening_grade']),
      writing: f(json['writing_grade']),
      reading: f(json['reading_grade']),
      speaking: f(json['speaking_grade']),
      midterm: f(json['midterm_grade']),
      finalScore: f(json['final_grade']),
      total: totalSum.toStringAsFixed(1),
      grade: _calculateGrade(totalSum),
    );
  }

  static String _calculateGrade(double score) {
    if (score >= 85) return "A";
    if (score >= 75) return "B+";
    if (score >= 65) return "B";
    if (score >= 50) return "C";
    return "F";
  }
}
