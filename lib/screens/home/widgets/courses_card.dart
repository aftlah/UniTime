// lib/screens/home/widgets/courses_card.dart
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class CoursesCard extends StatelessWidget {
  const CoursesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a look to your\ncourses & track your\nprogress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement navigation to courses screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Go to courses',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          // Pastikan Anda sudah menambahkan gambar ini di assets/images/books.png
          Image.asset('assets/images/books.png', height: 100),
        ],
      ),
    );
  }
}