import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:unitime/services/user_service.dart';
import '../models/schedule_model.dart';

class JadwalService {
  static const String baseUrl = 'https://api-moprog.aftlah.my.id/jadwal_kuliah';

  static Future<List<JadwalModel>> getAllJadwal() async {
    final user = await UserService.getUserLogin();

    if (user == null) {
      print("DEBUG: User belum login. Tidak bisa ambil jadwal.");
      return [];
    }

    try {
      final uri = Uri.parse('$baseUrl/read.php?user_id=${user.id}');
      final response = await http.get(uri);

      // print('DEBUG: Request URL: $uri');
      // print('DEBUG: Status: ${response.statusCode}');
      // print('DEBUG: Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true &&
            jsonData['data'] != null &&
            jsonData['data'] is List) {
          final List<dynamic> listData = jsonData['data'];
          return listData.map((item) => JadwalModel.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Gagal mengambil data jadwal: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR getAllJadwal: $e');
      return [];
    }
  }

  static Future<List<JadwalModel>> getJadwalByHari(String hari) async {
    final user = await UserService.getUserLogin();

    if (user == null) {
      print("DEBUG: User belum login");
      return [];
    }

    final uri = Uri.parse("$baseUrl/detail.php?user_id=${user.id}&hari=$hari");
    // print("DEBUG: Fetching schedule from $uri");

    try {
      final response = await http.get(uri);

      // print("DEBUG: Response code: ${response.statusCode}");
      // print("DEBUG: Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> listData = jsonData['data'];
          return listData.map((e) => JadwalModel.fromJson(e)).toList();
        } else {
          print("DEBUG: Tidak ada data jadwal untuk hari: $hari");
          return [];
        }
      } else {
        throw Exception(
            "Gagal mengambil data jadwal (status ${response.statusCode})");
      }
    } catch (e) {
      print("ERROR: $e");
      return [];
    }
  }

  static Future<bool> createJadwal(JadwalModel jadwal) async {
    final user = await UserService.getUserLogin();
    if (user == null) {
      throw Exception('Sesi Anda telah habis. Harap login kembali.');
    }

    final Map<String, String> body = {
      ...jadwal.toJson().map((key, value) => MapEntry(key, value.toString())),
      'user_id': user.id.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == false) {
          throw Exception(data['message'] ?? 'Terjadi kesalahan di server');
        }
        return true;
      } else {
        throw Exception(
            'Gagal terhubung ke server (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
