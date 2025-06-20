// class TugasModel {
//   final int? id;
//   final int userId;
//   // final String kodeMatkul;
//   // final String kelompok;
//   final String namaTugas;
//   final String matkul;
//   final String? deskripsi;
//   final DateTime deadline;
//   final String status;
//   final String createdAt;

//   TugasModel({
//     this.id, // id tidak wajib
//     required this.userId,
//     // required this.kodeMatkul,
//     // required this.kelompok,
//     required this.namaTugas,
//     required this.matkul,
//     required this.deskripsi,
//     required this.deadline,
//     required this.status,
//     required this.createdAt,
//   });

//   factory TugasModel.fromJson(Map<String, dynamic> json) {
//     return TugasModel(
//       id: json['id'] != null ? json['id'] as int : null,
//       userId: json['user_id'] as int,
//       // kodeMatkul: json['kode_matkul'] as String,
//       // kelompok: json['kelompok'] as String,
//       namaTugas: json['nama_tugas'] as String,
//       matkul: json['matkul'] as String,
//       deskripsi: json['deskripsi'] != null ? json['deskripsi'] as String : null,
//       deadline: DateTime.parse(json['deadline'] as String),
//       status: json['status'] as String,
//       createdAt: json['created_at'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       // 'kode_matkul': kodeMatkul,
//       // 'kelompok': kelompok,
//       'nama_tugas': namaTugas,
//       'matkul': matkul,
//       'deskripsi': deskripsi,
//       'deadline': deadline.toIso8601String(),
//       'status': status,
//       'created_at': createdAt,
//     };
//   }

//   TugasModel copyWith({
//     int? id,
//     int? userId,
//     // String? kodeMatkul,
//     // String? kelompok,
//     String? namaTugas,
//     String? matkul,
//     String? deskripsi,
//     DateTime? deadline,
//     String? status,
//     String? createdAt,
//   }) {
//     return TugasModel(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       // kodeMatkul: kodeMatkul ?? this.kodeMatkul,
//       // kelompok: kelompok ?? this.kelompok,
//       namaTugas: namaTugas ?? this.namaTugas,
//       matkul: matkul ?? this.matkul,
//       deskripsi: deskripsi ?? this.deskripsi,
//       deadline: deadline ?? this.deadline,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }


class TugasModel {
  final int id;
  final int userId;
  final String namaTugas;
  final String matkul;
  final String deskripsi;
  final DateTime deadline;
  final String status;
  final String createdAt;

  TugasModel({
    required this.id,
    required this.userId,
    required this.namaTugas,
    required this.matkul,
    required this.deskripsi,
    required this.deadline,
    required this.status,
    required this.createdAt,
  });

  TugasModel copyWith({
    int? id,
    int? userId,
    String? namaTugas,
    String? matkul,
    String? deskripsi,
    DateTime? deadline,
    String? status,
    String? createdAt,
  }) {
    return TugasModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      namaTugas: namaTugas ?? this.namaTugas,
      matkul: matkul ?? this.matkul,
      deskripsi: deskripsi ?? this.deskripsi,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaTugas: json['nama_tugas'] ?? 'Tanpa Judul',
      matkul: json['matkul'] ?? 'Umum',
      deskripsi: json['deskripsi'] ?? '',
      deadline:
          DateTime.tryParse(json['deadline'].toString()) ?? DateTime.now(),
      status: json['status'] ?? 'belum',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'user_id': userId.toString(),
      'nama_tugas': namaTugas,
      'matkul': matkul,
      'deskripsi': deskripsi,
      'deadline': deadline.toIso8601String(),
      'status': status,
    };
  }
}
