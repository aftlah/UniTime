import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart'; // Pastikan path ini benar

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  // Daftar opsi hari yang akan kita gunakan
  final List<String> _days = ['Kemarin', 'Hari Ini', 'Besok'];
  // State tetap menggunakan String agar mudah dibaca
  String selectedDay = 'Hari Ini'; 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bagian Header (Tidak berubah)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tugas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // === WIDGET PEMILIH HARI DENGAN ANIMASI GESER ===
        _buildAnimatedDaySelector(),

        const SizedBox(height: 20),

        // Bagian Kartu Tugas (Tidak berubah)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardGreen, // Asumsi warna ini ada di AppColors
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Pastikan path asset ini ada di pubspec.yaml dan proyek Anda
              // Image.asset('assets/icons/gambar1.png', height: 120),
              // const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kamu tidak memiliki tugas untuk $selectedDay!",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Tekan tombol + untuk menambahkan tugas baru"),
                  ],
                ),
              ),
              const SizedBox(width: 10),
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

  // Widget baru untuk membuat pemilih hari yang animatif
  Widget _buildAnimatedDaySelector() {
    return Container(
      height: 40, // Beri tinggi tetap untuk container
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / _days.length;
          final selectedIndex = _days.indexOf(selectedDay);

          return Stack(
            children: [
              // 1. Indikator aktif yang bisa bergeser
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: selectedIndex * itemWidth, // Pindahkan ke posisi yang benar
                child: Container(
                  width: itemWidth,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lightLavender,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // 2. Teks tombol yang ada di lapisan atas
              Row(
                children: _days.map((day) {
                  final bool isSelected = selectedDay == day;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      // Pastikan area tap mencakup seluruh slot
                      behavior: HitTestBehavior.opaque, 
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.darkPurple
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}