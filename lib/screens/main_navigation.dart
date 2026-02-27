import 'package:m_scms/screens/home/book_screen.dart';
import 'package:m_scms/screens/home/course_screen.dart';
import 'package:flutter/material.dart';
import 'package:m_scms/constants/constant.dart';
import 'package:m_scms/screens/home/home_screen.dart';
import 'package:m_scms/screens/home/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CourseScreen(),
    const BookScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kGreyColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.subject), label: 'Course'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
        ],
      ),
    );
  }
}
