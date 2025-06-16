
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class CoursesCard extends StatelessWidget {
  final VoidCallback onLihatTugasTapped;

  const CoursesCard({
    super.key,
    required this.onLihatTugasTapped,
  });

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
                const Text(
                  'Lihat Jadwal Kuliah Anda dan lihat progres tugas Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // 2. Gunakan callback di sini, bukan Navigator
                  onPressed: onLihatTugasTapped,
                  child: const Text(
                    'Lihat Tugas',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          // Pastikan path asset ini benar di pubspec.yaml
          Image.asset('assets/icons/gambar2.png', height: 150),
        ],
      ),
    );
  }
}
