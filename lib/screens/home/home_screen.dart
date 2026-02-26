import 'package:m_scms/providers/auth_provider.dart';
import 'package:m_scms/screens/home/course_screen.dart';
import 'package:m_scms/screens/home/notification_screen.dart';
import 'package:m_scms/screens/home/request_review_screen.dart';
import 'package:m_scms/screens/home/subject_screen.dart';
import 'package:flutter/material.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:provider/provider.dart';
import 'package:m_scms/screens/home/book_screen.dart';
import 'score_screen.dart';
import 'package:m_scms/screens/home/course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home Page',
              style: TextStyle(
                color: kDarkGreyColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Choose your course right away',
              style: TextStyle(
                color: kGreyColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: IconButton(
          //     icon: const Icon(Icons.refresh),
          //     color: const Color.fromARGB(255, 75, 51, 212),
          //     iconSize: 28,
          //     onPressed: () {
          //       Provider.of<AuthProvider>(context, listen: false).init();
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: const Color.fromARGB(255, 75, 51, 212),
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kLightGreyColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: kGreyColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search for your grade, course, training type...',
                      style: TextStyle(color: kGreyColor, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CourseScreen(),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    icon: Icons.live_tv,
                    title: 'All Course',
                    color: kBoutiqueColor,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubjectScreen(),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    icon: Icons.category,
                    title: 'All Subjects',
                    color: Colors.purple,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScoreScreen(),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    icon: Icons.score,
                    title: 'My Score',
                    color: Colors.green,
                  ),
                ),

                _buildCategoryCard(
                  icon: Icons.school,
                  title: 'Class',
                  color: Colors.blue,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestReviewScreen(),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    icon: Icons.score,
                    title: 'Request Review',
                    color: Colors.pink,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    icon: Icons.store,
                    title: 'Book',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended course',
                      style: TextStyle(
                        color: kDarkGreyColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'you may also like 😊',
                      style: TextStyle(color: kGreyColor, fontSize: 14),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CourseScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'More',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 200,
              child:
                  authProvider.isLoading && authProvider.allCourses.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : authProvider.allCourses.isEmpty
                      ? const Center(child: Text("No courses available"))
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            authProvider.allCourses.length > 10
                                ? 10
                                : authProvider.allCourses.length,
                        itemBuilder: (context, index) {
                          final course = authProvider.allCourses[index];
                          return _buildCourseCard(
                            title: course.subject.name,
                            rating: '4.8',
                            color: kPrimaryColor,
                            image: 'assets/course1.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CourseDetailScreen(course: course),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kWhiteColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kDarkGreyColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String rating,
    required Color color,
    required String image,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(child: Icon(Icons.book, color: color, size: 40)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: kDarkGreyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        rating,
                        style: TextStyle(
                          color: kDarkGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_border,
                          color: kAccentColor,
                          size: 12,
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
