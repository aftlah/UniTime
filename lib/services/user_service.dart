import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'https://aftlah.my.id/api-moprog/users';

  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil pengguna');
    }
  }

  static Future<UserModel> fetchUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail.php?id=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['data']);
    } else {
      throw Exception('Gagal mengambil detail pengguna');
    }
  }
  static Future<bool> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 200;
  }

  static Future<bool> updateUser(String id, UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        ...user.toJson(),
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteUser(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    return response.statusCode == 200;
  }

  static Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['data']);
    } else {
      throw Exception('Gagal login: ${response.body}');
    }
  }
  static Future<bool> logout(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    return response.statusCode == 200;
  }
  
}
