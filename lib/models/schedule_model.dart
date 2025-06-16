import 'dart:convert';

class JadwalModel {
  final int id;
  final int userId;
  final String kodeMatkul;
  final String namaMatkul;
  final String kelompok;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String createdAt;

  JadwalModel({
    required this.id,
    required this.userId,
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.kelompok,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
    required this.createdAt,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      // Mengonversi String dari JSON ke int dengan aman
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      kodeMatkul: json['kode_matkul'] ?? '',
      namaMatkul: json['nama_matkul'] ?? 'Tanpa Nama Matkul',
      kelompok: json['kelompok'] ?? '',
      hari: json['hari'] ?? '',
      jamMulai: json['jam_mulai'] ?? '00:00:00',
      jamSelesai: json['jam_selesai'] ?? '00:00:00',
      ruangan: json['ruangan'] ?? 'Tanpa Ruangan',
      createdAt: json['created_at'] as String,
    );
  }

  // Method untuk mengubah instance kelas menjadi Map (JSON)
  // Berguna saat mengirim data ke API (Create/Update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'kode_matkul': kodeMatkul,
      'nama_matkul': namaMatkul,
      'kelompok': kelompok,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'ruangan': ruangan,
      'created_at': createdAt,
    };
  }
}
