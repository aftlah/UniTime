import 'package:flutter/material.dart';
import 'package:unitime/models/schedule_model.dart';
import 'package:unitime/services/schedule_service.dart';
import 'package:unitime/utils/app_colors.dart';

import 'package:unitime/widgets/add_schedule_form.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late Future<List<JadwalModel>> _jadwalFuture;

  String _selectedDay = 'Semua';

  final List<String> _daysToDisplay = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu'
  ];

  @override
  void initState() {
    super.initState();
    _loadJadwal(_selectedDay);
  }

  void _loadJadwal(String mode) {
    setState(() {
      _selectedDay = mode;
      if (mode == 'Semua') {
        _jadwalFuture = JadwalService.getAllJadwal();
      } else {
        _jadwalFuture = JadwalService.getJadwalByHari(mode);
      }
    });
  }

  void _showAddScheduleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AddScheduleForm(onJadwalSaved: () {
          _loadJadwal(_selectedDay);
        });
      },
    );
  }

  Color _getColor(String title) {
    int hash = title.hashCode;
    switch (hash % 4) {
      case 0:
        return AppColors.cardBlue;
      case 1:
        return AppColors.cardGreen;
      case 2:
        return AppColors.cardYellow;
      case 3:
        return AppColors.cardPink;
      default:
        return AppColors.cardBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Jadwal Kuliah',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleForm,
        backgroundColor: AppColors.lightLavender,
        tooltip: 'Tambah Jadwal Kuliah',
        child: const Icon(Icons.add, color: AppColors.darkPurple),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWeekSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<JadwalModel>>(
                future: _jadwalFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()}"));
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    if (_selectedDay == 'Semua') {
                      return _buildScheduleList(snapshot.data!);
                    } else {
                      return _buildDayScheduleList(snapshot.data!);
                    }
                  }
                  return Center(
                      child: Text("Tidak ada jadwal untuk ditampilkan."));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(List<JadwalModel> allSchedules) {
    Map<String, List<JadwalModel>> gruopSchedule = {};
    for (var jadwal in allSchedules) {
      if (!gruopSchedule.containsKey(jadwal.hari)) {
        gruopSchedule[jadwal.hari] = [];
      }
      gruopSchedule[jadwal.hari]!.add(jadwal);
    }
    var sortDay = gruopSchedule.keys.toList()
      ..sort((a, b) =>
          _daysToDisplay.indexOf(a).compareTo(_daysToDisplay.indexOf(b)));

    return ListView.builder(
      itemCount: sortDay.length,
      itemBuilder: (context, index) {
        String hari = sortDay[index];
        String hariKapital =
            hari[0].toUpperCase() + hari.substring(1).toLowerCase();
        List<JadwalModel> schedulesForDay = gruopSchedule[hari]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                hariKapital,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
            ),
            ...schedulesForDay
                .map((jadwal) => _buildScheduleItem(
                    jadwal.jamMulai.substring(0, 5),
                    jadwal.namaMatkul,
                    '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}',
                    _getColor(jadwal.namaMatkul)))
                .toList(),
          ],
        );
      },
    );
  }

  Widget _buildDayScheduleList(List<JadwalModel> schedules) {
    if (schedules.isEmpty) {
      return Center(child: Text("Tidak ada jadwal untuk hari $_selectedDay."));
    }
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final jadwal = schedules[index];
        return _buildScheduleItem(
            jadwal.jamMulai.substring(0, 5),
            jadwal.namaMatkul,
            '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}',
            _getColor(jadwal.namaMatkul));
      },
    );
  }

  Widget _buildWeekSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                _selectedDay == 'Semua' ? 'Semua Jadwal' : 'Hari $_selectedDay',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextButton(
              onPressed: () => _loadJadwal('Semua'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: _selectedDay == 'Semua'
                      ? AppColors.lightLavender
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Lihat Semua',
                    style: TextStyle(
                      color: _selectedDay == 'Semua'
                          ? AppColors.darkPurple
                          : Colors.grey,
                      fontWeight: _selectedDay == 'Semua'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _daysToDisplay.map((day) {
            bool isActive = (day == _selectedDay);
            return GestureDetector(
              onTap: () => _loadJadwal(day),
              behavior: HitTestBehavior.opaque,
              child: _buildDate(day.substring(0, 3), isActive),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDate(String day, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: isActive ? AppColors.lightLavender : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(day,
              style: TextStyle(
                  color: isActive ? AppColors.darkPurple : Colors.grey,
                  fontSize: 13)),
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
                  color: color, borderRadius: BorderRadius.circular(15)),
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

// === SEMUA KODE UNTUK `AddScheduleForm` SUDAH DIHAPUS DARI FILE INI ===
// Karena sekarang dipanggil dari file terpisah (`add_schedule_form.dart`)
