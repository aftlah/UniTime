import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:unitime/models/schedule_model.dart';
import 'package:unitime/services/schedule_service.dart';
import 'package:unitime/screens/schedule/schedule_screen.dart';
import '../../../utils/app_colors.dart';
import 'package:unitime/widgets/add_schedule_form.dart';

class ScheduleCard extends StatefulWidget {

  final VoidCallback onLihatSemuaTapped;
  const ScheduleCard({super.key, required this.onLihatSemuaTapped});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late Future<List<JadwalModel>> _jadwalFuture;

  @override
  void initState() {
    super.initState();
    _refreshJadwalList();
  }

  void _refreshJadwalList() {
    setState(() {
      _jadwalFuture = JadwalService.getAllJadwal();
    });
  }

  void _showAddScheduleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AddScheduleForm(onJadwalSaved: _refreshJadwalList);
      },
    );
  }

  String _getNamaHariIni() {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: [
          //   const Text('Jadwal Kuliah Hari Ini',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //   TextButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const JadwalScreen()));
          //     },
          //     child: const Text('Lihat Semua',
          //         style: TextStyle(color: Colors.black)),
                  
          //   ),
          // ],

          children: [
            const Text('Jadwal Hari Ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: widget.onLihatSemuaTapped,
              icon: const Text('Lihat Semua'),
              label: const Icon(Icons.chevron_right, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<JadwalModel>>(
          future: _jadwalFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              final semuaJadwal = snapshot.data!;
              final namaHariIni = _getNamaHariIni();
              final jadwalHariIni = semuaJadwal
                  .where(
                      (j) => j.hari.toLowerCase() == namaHariIni.toLowerCase())
                  .toList();

              if (jadwalHariIni.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jadwalHariIni.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildJadwalContent(jadwalHariIni[index]),
                  );
                },
              );
            }
            return _buildEmptyState();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
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
              onPressed: _showAddScheduleForm,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tidak ada jadwal untuk hari ini!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
            child: const Icon(Icons.calendar_month_outlined,
                size: 30, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jadwal.namaMatkul,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text("Pukul $waktuMulaiFormatted - $waktuSelesaiFormatted",
                    style: TextStyle(color: Colors.black.withOpacity(0.7))),
                const SizedBox(height: 4),
                Text("Ruangan: ${jadwal.ruangan}",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade800, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
                "Gagal memuat jadwal: ${error.replaceAll('Exception: ', '')}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

