// class UserModel {
//   final int id;
//   final String username;
//   final String email;
//   final String universitas;
//   final String jurusan;
//   final String? password; // Optional jika memang ingin disimpan

//   UserModel({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.universitas,
//     required this.jurusan,
//     this.password,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       universitas: json['universitas'] ?? '',
//       jurusan: json['jurusan'] ?? '',
//       password: json['password'], 
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//       'universitas': universitas,
//       'jurusan': jurusan,
//       if (password != null) 'password': password,
//     };
//   }
// }

class UserModel {
  final int id;
  final String username;
  final String email;
  final String universitas;
  final String jurusan;
  final String? password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.universitas,
    required this.jurusan,
    this.password,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? universitas,
    String? jurusan,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      universitas: universitas ?? this.universitas,
      jurusan: jurusan ?? this.jurusan,
      password: password ?? this.password,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      universitas: json['universitas'] ?? '',
      jurusan: json['jurusan'] ?? '',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'universitas': universitas,
      'jurusan': jurusan,
      if (password != null) 'password': password,
    };
  }
}