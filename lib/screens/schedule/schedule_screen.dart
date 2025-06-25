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

  void _loadJadwal([String? day]) {
    final effectiveDay = day ?? _selectedDay;
    setState(() {
      _selectedDay = effectiveDay;
      if (effectiveDay == 'Semua') {
        _jadwalFuture = JadwalService.getAllJadwal();
      } else {
        _jadwalFuture = JadwalService.getJadwalByHari(effectiveDay);
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      ),
    );
  }

  void _showAddScheduleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AddScheduleForm(onJadwalSaved: () {
          _loadJadwal();
        });
      },
    );
  }

  void _showEditScheduleForm(JadwalModel jadwal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddScheduleForm(
        onJadwalSaved: () => _loadJadwal(),
        initialJadwal: jadwal,
      ),
    );
  }

  Future<void> _handleDeleteJadwal(JadwalModel jadwal) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content:
            Text('Anda yakin ingin menghapus jadwal "${jadwal.namaMatkul}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        final success = await JadwalService.deleteJadwal(jadwal.id.toString());
        if (success) {
          _showSnackBar('Jadwal berhasil dihapus!');
          _loadJadwal();
        }
      } catch (e) {
        _showSnackBar(
            'Gagal menghapus jadwal: ${e.toString().replaceAll("Exception: ", "")}',
            isError: true);
      }
    }
  }

  Color _getColor(String title) {
    int hash = title.hashCode;
    print(hash);
    switch (hash.abs() % 4) {
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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text('Jadwal Kuliah',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddScheduleForm,
      //   backgroundColor: AppColors.lightLavender,
      //   tooltip: 'Tambah Jadwal Kuliah',
      //   child: const Icon(Icons.add, color: AppColors.darkPurple),
        
      // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()}"));
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    if (_selectedDay == 'Semua') {
                      return _buildScheduleList(snapshot.data!);
                    } else {
                      return _buildDayScheduleList(snapshot.data!);
                    }
                  }
                  return const Center(
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
    Map<String, List<JadwalModel>> groupSchedule = {};
    for (var jadwal in allSchedules) {
      if (!groupSchedule.containsKey(jadwal.hari))
        groupSchedule[jadwal.hari] = [];
      groupSchedule[jadwal.hari]!.add(jadwal);
    }
    var sortDay = groupSchedule.keys.toList()
      ..sort((a, b) =>
          _daysToDisplay.indexOf(a).compareTo(_daysToDisplay.indexOf(b)));

    return ListView.builder(
      itemCount: sortDay.length,
      itemBuilder: (context, index) {
        String hari = sortDay[index];
        String hariKapital =
            hari[0].toUpperCase() + hari.substring(1).toLowerCase();
        List<JadwalModel> schedulesForDay = groupSchedule[hari]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                hariKapital,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
            ),
            ...schedulesForDay
                .map((jadwal) => _buildScheduleItem(jadwal))
                .toList(),
          ],
        );
      },
    );
  }

  Widget _buildDayScheduleList(List<JadwalModel> schedules) {
    if (schedules.isEmpty)
      return Center(child: Text("Tidak ada jadwal untuk hari $_selectedDay."));
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return _buildScheduleItem(schedules[index]);
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

  Widget _buildScheduleItem(JadwalModel jadwal) {
    final time = jadwal.jamMulai.substring(0, 5);
    final title = jadwal.namaMatkul;
    // print(jadwal);
    final duration = '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}';
    final color = _getColor(jadwal.namaMatkul);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(duration,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black87),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditScheduleForm(jadwal);
                      } else if (value == 'delete') {
                        _handleDeleteJadwal(jadwal);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20, color: Colors.blue),
                            const SizedBox(width: 10),
                            const Text('Edit', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            const SizedBox(width: 10),
                            const Text('Hapus', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
