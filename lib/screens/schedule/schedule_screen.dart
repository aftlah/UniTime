import 'package:flutter/material.dart';
import 'package:unitime/utils/app_colors.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Schedule',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWeekSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildScheduleItem('8:00am', 'Basic mathematics',
                      '08:00am - 8:45am', AppColors.cardBlue),
                  _buildScheduleItem('10:00am', 'English Grammar',
                      '10:00am - 11:10am', AppColors.cardGreen),
                  _buildScheduleItem('12:00am', 'Science', '12:00am - 12:45am',
                      AppColors.cardYellow),
                  _buildScheduleItem('1:00pm', 'World history',
                      '1:00am - 1:45am', AppColors.cardPink),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('This week',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('See all'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDate('SUN', '04', false),
            _buildDate('MON', '05', false),
            _buildDate('TUE', '06', false),
            _buildDate('WED', '07', false),
            _buildDate('THE', '08', true), // Today
            _buildDate('FRI', '09', false),
            _buildDate('SAT', '10', false),
          ],
        ),
      ],
    );
  }

  Widget _buildDate(String day, String date, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(day,
              style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(date,
              style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
      String time, String title, String duration, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(duration,
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
