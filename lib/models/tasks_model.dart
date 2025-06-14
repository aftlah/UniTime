class TugasModel {
  final int id;
  final int userId;
  final String kodeMatkul;
  final String kelompok;
  final String namaTugas;
  final String matkul;
  final String deskripsi;
  final DateTime deadline;
  final String status;
  final String createdAt;

  TugasModel({
    required this.id,
    required this.userId,
    required this.kodeMatkul,
    required this.kelompok,
    required this.namaTugas,
    required this.matkul,
    required this.deskripsi,
    required this.deadline,
    required this.status,
    required this.createdAt,
  });

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'],
      userId: json['user_id'],
      kodeMatkul: json['kode_matkul'],
      kelompok: json['kelompok'],
      namaTugas: json['nama_tugas'],
      matkul: json['matkul'],
      deskripsi: json['deskripsi'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'kode_matkul': kodeMatkul,
      'kelompok': kelompok,
      'nama_tugas': namaTugas,
      'matkul': matkul,
      'deskripsi': deskripsi,
      'deadline': deadline.toIso8601String(),
      'status': status,
      'created_at': createdAt,
    };
  }
}
