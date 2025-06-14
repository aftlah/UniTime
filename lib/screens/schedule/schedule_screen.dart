import 'package:flutter/material.dart';
import 'package:unitime/utils/app_colors.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Jadwal Kuliah',
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
                  _buildScheduleItem('8:00', 'Matematika',
                      '08:00 - 08:45', AppColors.cardBlue),
                  _buildScheduleItem('10:00', 'Bahasa Inggris',
                      '10:00 - 11:10', AppColors.cardGreen),
                  _buildScheduleItem('12:00', 'Ilmu Pengetahuan Alam',
                      '12:00 - 12:45', AppColors.cardYellow),
                  _buildScheduleItem('1:00', 'Sejarah Dunia',
                      '13:00 - 13:45', AppColors.cardPink),
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
        Text('Minggu Ini',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text('Lihat Semua'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        _buildDate('Senin', false),
        _buildDate('Selasa', false),
        _buildDate('Rabu', false),
        _buildDate('Kamis', false),
        _buildDate('Jumat', true),
        _buildDate('Sabtu', false),
          ],
        ),
      ],
    );
  }

  Widget _buildDate(String day, bool isActive) {
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
