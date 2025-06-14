class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String universitas;
  final String jurusan;
  final String createdAt;

  UserModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.password,
      required this.universitas,
      required this.jurusan,
      required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      universitas: json['universitas'],
      jurusan: json['jurusan'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'universitas': universitas,
      'jurusan': jurusan,
      'created_at': createdAt,
    };
  }
}