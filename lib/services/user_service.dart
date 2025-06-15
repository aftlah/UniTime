import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'https://api-moprog.aftlah.my.id/users';
  static const String _userKey = 'userData';

  static Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = response.body;

      final data = jsonDecode(body);
      // print("Login Response: $data");

      final message = data['message'] ?? 'Terjadi kesalahan';

      if (response.statusCode == 200 &&
          data['status'] == true &&
          data['data'] != null) {
        final user = UserModel.fromJson(data['data']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(data['data']));
        return user;
      } else {
        throw Exception(message);
      }
    } catch (e) {
      print("Login Error: $e");
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<String> register(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['status'] == true) {
        return data['message'] ?? 'Registrasi berhasil';
      } else {
        throw Exception(data['message'] ?? 'Gagal melakukan registrasi');
      }
    } else {
      throw Exception(data['message'] ?? 'Terjadi kesalahan pada server');
    }
  }

  static Future<UserModel?> getUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString);
      return UserModel.fromJson(userDataJson);
    }
    // Jika tidak ada data, kembalikan null
    return null;
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
}
