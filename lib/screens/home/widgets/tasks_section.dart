// lib/screens/home/widgets/tasks_section.dart
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(onPressed: () {}, child: const Text('Yesterday')),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Today'),
            ),
            TextButton(onPressed: () {}, child: const Text('Tomorrow')),
          ],
        ),
        const SizedBox(height: 20),
        // Kartu untuk state ketika tidak ada tugas
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Pastikan Anda menambahkan gambar ini di assets/images/girl_at_desk.png
              Image.asset('assets/images/girl_at_desk.png', height: 100),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You don't have any tasks!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Press + button to add new tasks"),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement add new task functionality
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
