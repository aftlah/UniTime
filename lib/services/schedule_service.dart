import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/schedule_model.dart';

class JadwalService {
  static const String baseUrl = 'https://api-moprog.aftlah.my.id/jadwal_kuliah';

  static Future<List<JadwalModel>> getAllJadwal() async {
    final response = await http.get(
      Uri.parse('$baseUrl/read.php'),
    );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == true && data['data'] != null && data['data'] is List) {

        final List<dynamic> listData = data['data'];
        return listData.map((json) => JadwalModel.fromJson(json)).toList();

      } else {
        return [];
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }

  // GET Detail Jadwal by ID
  static Future<JadwalModel> getDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail.php?id=$id'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return JadwalModel.fromJson(body['data']);
    } else {
      throw Exception('Gagal mengambil detail jadwal');
    }
  }

  // POST (Create) Jadwal
  static Future<bool> createJadwal(JadwalModel jadwal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add.php'),
      body: jadwal.toJson(),
    );

    return response.statusCode == 200;
  }

  // PUT/POST (Update) Jadwal
  static Future<bool> updateJadwal(String id, JadwalModel jadwal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      body: {
        'id': id,
        ...jadwal.toJson(),
      },
    );

    return response.statusCode == 200;
  }

  // DELETE Jadwal
  static Future<bool> deleteJadwal(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      body: {
        'id': id,
      },
    );

    return response.statusCode == 200;
  }
}
