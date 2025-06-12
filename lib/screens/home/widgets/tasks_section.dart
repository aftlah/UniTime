import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  String selectedDay = 'Today';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDayButton('Yesterday'),
            _buildDayButton('Today'),
            _buildDayButton('Tomorrow'),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Image.asset('assets/icons/gambar1.png', height: 120),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You don't have any tasks for $selectedDay!",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Press + button to add new tasks"),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayButton(String day) {
    final bool isSelected = selectedDay == day;
    
    if (isSelected) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            selectedDay = day;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        child: Text(day),
      );
    } else {
      return TextButton(
        onPressed: () {
          setState(() {
            selectedDay = day;
          });
        },
        child: Text(
          day,
          style: const TextStyle(color: AppColors.secondaryText),
        ),
      );
    }
  }
}