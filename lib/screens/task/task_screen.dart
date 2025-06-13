import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Impor package intl

// Model data untuk Tugas (Tidak berubah)
class Task {
  final String title;
  final String duration;
  final String status;
  final Color color;

  Task({
    required this.title,
    required this.duration,
    required this.status,
    required this.color,
  });
}

// Ubah menjadi StatefulWidget
class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  // State untuk menyimpan bulan yang ditampilkan dan tanggal yang dipilih
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan tanggal hari ini
    _displayedMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  // Fungsi untuk berpindah bulan
  void _changeMonth(int direction) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + direction,
        1,
      );
    });
  }

  // Data dummy untuk daftar tugas
  final List<Task> tasks = [
    Task(
      title: 'Tugas1',
      duration: '30 hari',
      status: 'Selesai',
      color: const Color(0xFFF9F0FF), // Light Purple
    ),
    Task(
      title: 'Tugas2',
      duration: '60 hari',
      status: 'Belum Selesai',
      color: const Color(0xFFFFF9E6), // Light Yellow
    ),
    Task(
      title: 'Tugas3',
      duration: '40 hari',
      status: 'Belum Selesai',
      color: const Color(0xFFEBF5FF), // Light Blue
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildCalendar(),
              const SizedBox(height: 40),
              _buildTasksSectionHeader(),
              const SizedBox(height: 20),
              ...tasks.map((task) => _TaskItem(task: task)).toList(),
              const SizedBox(height: 120),
            ],
          ),
          // _buildBottomNavBar(), // Sesuai kode Anda, ini di-comment
        ],
      ),
    );
  }

  // Widget untuk header "Kalender"
  Widget _buildHeader() {
    return Text(
      'Kalender',
      style: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Widget untuk bagian Kalender
  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const SizedBox(height: 20),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  // Header di dalam kalender (Bulan, Tahun, dan navigasi)
  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menggunakan data dinamis dari state
        Text(
          DateFormat('MMMM yyyy')
              .format(_displayedMonth), // Contoh: "January 2025"
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            // Tombol navigasi bulan sebelumnya
            InkWell(
              onTap: () => _changeMonth(-1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_left, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol navigasi bulan berikutnya
            InkWell(
              onTap: () => _changeMonth(1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_right, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Grid tanggal kalender (LOGIKA UTAMA YANG BERUBAH)
  Widget _buildCalendarGrid() {
    final List<String> daysOfWeek = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    // Minggu (7) menjadi 0, Senin (1) menjadi 1, dst.
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Baris untuk nama hari (statis)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek
              .map((day) => Text(
                    day,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  ))
              .toList(),
        ),
        // const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          // Total item = hari kosong di awal + jumlah hari dalam sebulan
          itemCount: daysInMonth + startWeekday,
          itemBuilder: (context, index) {
            // Jika index lebih kecil dari hari pertama, tampilkan container kosong
            if (index < startWeekday) {
              return Container();
            }

            final dayNumber = index - startWeekday + 1;
            final currentDate = DateTime(
                _displayedMonth.year, _displayedMonth.month, dayNumber);

            // Cek apakah tanggal ini adalah tanggal yang dipilih
            final bool isSelected = _selectedDate != null &&
                DateUtils.isSameDay(currentDate, _selectedDate!);

            // Logika styling untuk demo (sama seperti desain)
            bool hasTask1 = dayNumber == 24;
            bool hasTask2 = dayNumber == 25;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = currentDate;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00BFA5) // Teal
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (hasTask1 || hasTask2)
                        ? const Color(0xFF00BFA5).withOpacity(0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '$dayNumber',
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Header untuk bagian "Tasks"
  Widget _buildTasksSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tugas', // Diubah ke Bahasa Indonesia
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'Selesai  1/3', // Diubah ke Bahasa Indonesia
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// Widget terpisah untuk setiap item tugas (Tidak berubah)
class _TaskItem extends StatelessWidget {
  final Task task;
  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.timer_outlined,
                      color: Colors.grey.shade600, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    task.duration,
                    style: GoogleFonts.poppins(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
          Text(
            task.status,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // Logika warna status diubah sedikit agar sesuai dengan teks baru
              color: task.status == 'Selesai'
                  ? Colors.deepPurple.shade300
                  : Colors.orange.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
