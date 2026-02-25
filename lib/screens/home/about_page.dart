import 'package:flutter/material.dart';
import 'package:eduwlc/constants/constant.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProjectHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("PROJECT OVERVIEW"),
                  const SizedBox(height: 12),
                  _buildDescriptionCard(),
                  const SizedBox(height: 40),
                  _buildSectionTitle("TEAM MEMBERS (G2 MS)"),
                  const SizedBox(height: 12),
                  _buildTeamSection(),
                  const SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ App Bar ═══════════════════
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Project Information',
        style: TextStyle(
          color: kWhiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: kWhiteColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // ═══════════════════ Project Header ═══════════════════
  Widget _buildProjectHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor,
            kPrimaryColor.withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: 'wlc_logo',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/wlc_logo.png',
                height: 70,
                width: 70,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.school, size: 70, color: kPrimaryColor);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "G2 MS - Thesis Project",
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "2025-2026",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "WLC School Information System",
              style: TextStyle(
                color: kWhiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ Description Card ═══════════════════
  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: kPrimaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "About This Project",
                style: TextStyle(
                  color: kDarkGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "The School Information System is a final-year thesis project designed to modernize school operations at WLC. "
            "The system provides students, teachers, and administrators with real-time access to academic records, schedules, "
            "announcements, and enrollment information through a modern mobile application.",
            style: TextStyle(
              color: kDarkGreyColor,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════ Team Section ═══════════════════
  Widget _buildTeamSection() {
    final members = [
      _TeamMember(
        name: "Song Piseth",
        description: "TEAM LEADER",
        role: "Team Leader & Project Manager",
        image: "assets/piseth.jpg",
        skills: ["Leadership", "Planning", "Scrum"],
        color: const Color(0xFF6366F1),
      ),
      _TeamMember(
        name: "Suon Phanun",
        description: "LEAD DEVELOPER",
        role: "Full-stack Developer & Project Architect",
        image: "assets/nun.jpg",
        skills: ["Flutter", "Laravel", "REST API", "MySQL", "Git"],
        color: const Color(0xFF8B5CF6),
      ),
      _TeamMember(
        name: "Vuth Vannak",
        description: "CREATIVE DIRECTOR",
        role: "UI/UX Designer",
        image: "assets/vannak.jpg",
        skills: ["Figma", "Adobe XD", "Prototyping"],
        color: const Color(0xFFEC4899),
      ),
      _TeamMember(
        name: "Vinhean Reathey",
        description: "RESEARCH SPECIALIST",
        role: "Researcher",
        image: "assets/Vinhean_Reathey.jpg",
        skills: ["Research Methodology", "Data Analysis", "Academic Writing", "Literature Review"],
        color: const Color(0xFF10B981),
      ),
      _TeamMember(
        name: "Manickam Rama",
        description: "DATABASE ARCHITECT",
        role: "Database Designer",
        image: "assets/Manickam_Rama.jpg",
        skills: ["MySQL", "ERD", "Normalization"],
        color: const Color(0xFFF59E0B),
      ),
      _TeamMember(
        name: "LAV TIT",
        description: "FRONTEND SPECIALIST",
        role: "Frontend Developer & QA",
        image: "assets/LAV_TIT.jpg",
        skills: ["Flutter", "Testing", "Debugging"],
        color: const Color(0xFF3B82F6),
      ),
    ];

    return Column(
      children: members.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildMemberCard(entry.value, entry.key),
        );
      }).toList(),
    );
  }

  // ═══════════════════ Member Card ═══════════════════
  Widget _buildMemberCard(_TeamMember member, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: member.color.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: member.color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage(member.image),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: member.color.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: member.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: kWhiteColor, width: 2),
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: kWhiteColor,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: kDarkGreyColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (member.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: member.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        member.description,
                        style: TextStyle(
                          color: member.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 14,
                        color: const Color.fromARGB(255, 93, 246, 55),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          member.role,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: member.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              member.color.withOpacity(0.1),
                              member.color.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: member.color.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            color: member.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════ Section Title ═══════════════════
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: kDarkGreyColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ═══════════════════ Footer ═══════════════════
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.05),
            kPrimaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Made with",
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.favorite, color: Colors.red, size: 16),
              const SizedBox(width: 6),
              const Text(
                "using Flutter & Laravel",
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "© 2026 G2 MS Team • All Rights Reserved",
              style: TextStyle(
                color: kDarkGreyColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════ Team Member Model ═══════════════════
class _TeamMember {
  final String name;
  final String description;
  final String role;
  final String image;
  final List<String> skills;
  final Color color;

  _TeamMember({
    required this.name,
    this.description = '',
    required this.role,
    required this.image,
    required this.skills,
    this.color = const Color(0xFF6366F1),
  });
}