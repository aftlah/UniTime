// lib/models/jadwal_model.dart

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

  // copyWith ini  buat ngegandain objek JadwalModel, tapi kamu bisa ganti beberapa aja sesuai kebutuhan. Jadi data aslinya nggak ikut berubah, yang berubah cuma hasil copy aja Biasanya dipake biar data tetap aman dan ga ketimpa.
  JadwalModel copyWith({
    int? id,
    int? userId,
    String? kodeMatkul,
    String? namaMatkul,
    String? kelompok,
    String? hari,
    String? jamMulai,
    String? jamSelesai,
    String? ruangan,
    String? createdAt,
  }) {
    return JadwalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      kodeMatkul: kodeMatkul ?? this.kodeMatkul,
      namaMatkul: namaMatkul ?? this.namaMatkul,
      kelompok: kelompok ?? this.kelompok,
      hari: hari ?? this.hari,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
      ruangan: ruangan ?? this.ruangan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      kodeMatkul: json['kode_matkul'] ?? '',
      namaMatkul: json['nama_matkul'] ?? 'Tanpa Nama Matkul',
      kelompok: json['kelompok'] ?? '',
      hari: json['hari'] ?? 'Senin',
      jamMulai: json['jam_mulai'] ?? '00:00:00',
      jamSelesai: json['jam_selesai'] ?? '00:00:00',
      ruangan: json['ruangan'] ?? 'Tanpa Ruangan',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'kode_matkul': kodeMatkul,
      'nama_matkul': namaMatkul,
      'kelompok': kelompok,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'ruangan': ruangan,
      // 'created_at' biasanya tidak dikirim saat create/update
    };
  }
}
