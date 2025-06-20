import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'widgets/courses_card.dart';
import 'widgets/schedule_card.dart';
import 'widgets/tasks_section.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToTugas;

  const HomeScreen({
    super.key,
    required this.onNavigateToTugas,
  });

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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications_none, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoursesCard(
              onLihatTugasTapped: onNavigateToTugas,
            ),
            const SizedBox(height: 20),
            ScheduleCard(onLihatSemuaTapped: onNavigateToTugas),
            const SizedBox(height: 20),
            TasksSection(onLihatSemuaTapped: onNavigateToTugas),
          ],
        ),
      ),
    );
  }
}
