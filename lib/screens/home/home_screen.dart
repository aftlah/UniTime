// lib/screens/home/home_screen.dart (Kode Lengkap)

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'widgets/courses_card.dart';
import 'widgets/schedule_card.dart';
import 'widgets/tasks_section.dart';

class HomeScreen extends StatelessWidget {
  // 1. Tambahkan parameter fungsi callback untuk navigasi
  final VoidCallback onNavigateToTugas;

  const HomeScreen({
    super.key,
    required this.onNavigateToTugas, // Jadikan required
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Hapus 'const' dari Column ini
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Teruskan fungsi callback ke CoursesCard
            CoursesCard(
              onLihatTugasTapped: onNavigateToTugas,
            ),
            const SizedBox(height: 20),
            // Pastikan Anda memiliki widget ScheduleCard ini
            const ScheduleCard(),
            const SizedBox(height: 20),
            // Pastikan Anda memiliki widget TasksSection ini
            const TasksSection(),
          ],
        ),
      ),
    );
  }
}
