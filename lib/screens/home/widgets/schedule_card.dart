// lib/screens/home/widgets/premium_banner.dart
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jadwal Kuliah',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Lihat Semua',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardPink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
                CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                  print('Tambah Jadwal Kuliah');
                  },
                ),
                ),
                const SizedBox(width: 16), // Tambahkan jarak antar widget
                Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    // "You don't have any tasks for today!",
                    "Tidak ada jadwal untuk hari ini!",
                    style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4), // Jarak antar teks
                  const Text("Tekan tombol + untuk menambahkan jadwal baru"),
                  ],
                ),
                ),
              const SizedBox(width: 20),
              Image.asset('assets/icons/jadwal-image.png', height: 120),
            ],
          ),
        ),
      ],
    );
  }
}
