import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/screens/auth/login_user.dart';
import 'package:m_scms/screens/home/about_page.dart';
import 'package:m_scms/screens/home/enrollment_page.dart';
import 'package:m_scms/screens/home/notification_page.dart';
import 'package:m_scms/screens/home/password_page.dart';
import 'package:m_scms/screens/home/score_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/constants/app_url.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    if (authProvider.isLoading && userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_off_outlined,
                size: 60,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => authProvider.fetchUserProfile(),
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                child: const Text(
                  'Retry Load Profile',
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final String userName = userData['name'] ?? 'User Name N/A';
    final String userEmail = userData['email'] ?? 'N/A';
    final String avatarPath = userData['avatar'] ?? '';

    final String fullAvatarUrl = avatarPath.isNotEmpty
        ? "${Appurl.url}/$avatarPath".replaceFirst('127.0.0.1', '10.0.2.2')
        : '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhiteColor),
            onPressed: () => authProvider.fetchUserProfile(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _buildHeaderBackground(context),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  child: Column(
                    children: [
                      _buildPremiumAvatar(fullAvatarUrl),
                      const SizedBox(height: 12),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: kWhiteColor.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(bottom: -40, child: _buildStatsCard(userData)),
              ],
            ),

            const SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "GENERAL SETTINGS",
                    style: TextStyle(
                      color: kGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuSection([
                    _buildModernMenuItem(
                      icon: Icons.leaderboard,
                      title: 'My Enrollment',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnrollmentPage(),
                          ),
                        );
                      },
                    ),
                    _buildModernMenuItem(
                      icon: Icons.book_outlined,
                      title: 'My Score',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScorePage(),
                          ),
                        );
                      },
                    ),
                    _buildModernMenuItem(
                      icon: Icons.card_membership,
                      title: 'Certificates',
                      color: Colors.orange,
                      onTap: () {},
                    ),

                    _buildModernMenuItem(
                      icon: Icons.key,
                      title: 'Change Password',
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    _buildModernMenuItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),
                  const Text(
                    "SUPPORT",
                    style: TextStyle(
                      color: kGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuSection([
                    _buildModernMenuItem(
                      icon: Icons.info_outline,
                      title: 'About App',
                      color: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutAppPage(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildLogoutButton(context, authProvider),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, Color(0xFF634EFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Widget _buildPremiumAvatar(String url) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: kWhiteColor,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: kWhiteColor,
        child: ClipOval(
          child: url.isNotEmpty
              ? Image.network(
                  url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/wlc_logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                )
              : Image.asset(
                  'assets/wlc_logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(dynamic userData) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            'Courses',
            userData['courses_count']?.toString() ?? '0',
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            'Hours',
            userData['hours_completed']?.toString() ?? '0',
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            'Certfs',
            userData['certificates_count']?.toString() ?? '0',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: kGreyColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }

  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: kDarkGreyColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: kGreyColor,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return InkWell(
      onTap: () async {
        await authProvider.logout();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginUser()),
            (route) => false,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Logout Account',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
