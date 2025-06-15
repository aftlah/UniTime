import 'package:flutter/material.dart';
import 'package:unitime/models/schedule_model.dart';
import 'package:unitime/services/schedule_service.dart';
import 'package:unitime/screens/schedule/schedule_screen.dart';
import '../../../utils/app_colors.dart';

class ScheduleCard extends StatefulWidget {
  const ScheduleCard({super.key});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late Future<List<JadwalModel>> _jadwalFuture;

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  void _loadJadwal() {
    _jadwalFuture = JadwalService.getAllJadwal();
  }

  String _getNamaHariIni() {
    // ... (Fungsi ini sudah benar)
    switch (DateTime.now().weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jadwal Kuliah Hari Ini', // Judul lebih spesifik
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JadwalScreen()),
                );
              },
              child: const Text('Lihat Semua',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // FutureBuilder
        FutureBuilder<List<JadwalModel>>(
          future: _jadwalFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              // Blok ini sekarang hanya akan menangani error koneksi/server
              return _buildErrorState(snapshot.error.toString());
            }

            // `snapshot.hasData` akan true bahkan untuk list kosong
            if (snapshot.hasData) {
              final semuaJadwal = snapshot.data!;
              final namaHariIni = _getNamaHariIni();

              final jadwalHariIni = semuaJadwal.where((jadwal) {
                // Gunakan toLowerCase() untuk perbandingan yang aman
                return jadwal.hari.toLowerCase() == namaHariIni.toLowerCase();
              }).toList();

              if (jadwalHariIni.isEmpty) {
                // Kondisi ini akan menangani dua kasus:
                // 1. Tidak ada jadwal sama sekali (semuaJadwal kosong).
                // 2. Ada jadwal, tapi tidak ada untuk hari ini.
                return _buildEmptyState();
              } else {
                // Tampilkan jadwal untuk hari ini
                return Column(
                  children: jadwalHariIni
                      .map((jadwal) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildJadwalContent(jadwal),
                          ))
                      .toList(),
                );
              }
            }

            // Fallback, seharusnya tidak pernah tercapai jika logic di atas benar
            return _buildEmptyState();
          },
        ),
      ],
    );
  }

  // --- Widget Builder Functions (Tidak ada perubahan di bawah ini) ---

  Widget _buildEmptyState() {
    // ... (kode Anda sudah bagus)
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black.withOpacity(0.8),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                // TODO: Navigasi ke halaman Tambah Jadwal Kuliah
                print('Navigasi ke halaman Tambah Jadwal Kuliah');
              },
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tidak ada jadwal untuk hari ini!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text("Tekan tombol + untuk menambahkan jadwal baru"),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Image.asset('assets/icons/jadwal-image.png', height: 100),
        ],
      ),
    );
  }

  Widget _buildJadwalContent(JadwalModel jadwal) {
    // ... (kode Anda sudah bagus)
    final waktuMulaiFormatted = jadwal.jamMulai.substring(0, 5);
    final waktuSelesaiFormatted = jadwal.jamSelesai.substring(0, 5);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_month_outlined,
                size: 30, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.namaMatkul,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Pukul $waktuMulaiFormatted - $waktuSelesaiFormatted",
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ruangan: ${jadwal.ruangan}",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    // ... (kode Anda sudah bagus)
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
    // Bersihkan pesan error agar lebih rapi
    final cleanedError = error.replaceAll('Exception: ', '');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade800, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Gagal memuat jadwal: $cleanedError",
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
