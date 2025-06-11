// lib/screens/home/home_screen.dart (Updated)
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'widgets/courses_card.dart';
import 'widgets/premium_banner.dart';
import 'widgets/tasks_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoursesCard(),
            SizedBox(height: 20),
            PremiumBanner(),
            SizedBox(height: 20),
            TasksSection(),
          ],
        ),
      ),
    );
  }
}
