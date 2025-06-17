import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unitime/models/tasks_model.dart';
import 'package:unitime/services/user_service.dart';

class TugasService {
  static const String baseUrl = 'https://api-moprog.aftlah.my.id/tugas';

  static Future<List<TugasModel>> fetchTugas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read.php'));

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody is List) {
          return jsonBody.map((item) => TugasModel.fromJson(item)).toList();
        } else if (jsonBody['data'] != null) {
          // Kalau API-mu mengembalikan {"data": [...]}
          return (jsonBody['data'] as List)
              .map((item) => TugasModel.fromJson(item))
              .toList();
        } else {
          throw Exception('Format data tidak dikenali');
        }
      } else {
        throw Exception(
            'Gagal mengambil data tugas (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil tugas: $e');
    }
  }

  static Future<List<TugasModel>> getTugas() async {
    final user = await UserService.getUserLogin();

    // print("DEBUG: user = $user");
    // print("DEBUG: user.id = ${user?.id}");

    if (user == null) {
      // print("DEBUG: User null, return tugas kosong.");
      return [];
    }

    final uri = Uri.parse('$baseUrl/detail.php?user_id=${user.id}');

    // print("DEBUG:  API T: $uri");

    try {
      final response = await http.get(uri);

      // print("DEBUG: Response Status Code: ${response.statusCode}");
      // print("DEBUG: Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // print('MASUOOOKKKKKKKKKKKKKKKKKKKKK');
        final data = jsonDecode(response.body);

        if (data['status'] == true &&
            data['data'] != null &&
            data['data'] is List) {
          final List<dynamic> listData = data['data'];
          return listData.map((json) => TugasModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Gagal memuat tugas dari server');
      }
    } catch (e) {
      print("DEBUG: Terjadi error pada HTTP call: $e");
      throw Exception('Terjadi kesalahan jaringan atau koneksi ke server');
    }
  }

  static Future<bool> createTugas(TugasModel tugas) async {
    final user = await UserService.getUserLogin();

    if (user == null) {
      throw Exception('User tidak login. Silakan login kembali.');
    }

    final Map<String, String> body = {
      ...tugas.toJson().map((key, value) => MapEntry(key, value.toString())),
      'user_id': user.id.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add.php'),
        body: body,
      );

      print("DEBUG Status Code: ${response.statusCode}");
      print("DEBUG Response Body: ${response.body}");

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

  static Future<bool> updateTugas(String id, TugasModel tugas) async {
    try {
      final user = await UserService.getUserLogin();
      if (user == null) {
        throw Exception('User tidak login. Silakan login kembali.');
      }

      final tugasJson = tugas.toJson();
      tugasJson.remove('id'); 

      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'user_id': user.id.toString(),
          ...tugasJson,
        }),
      );

      print("DEBUG: Update Response Status: ${response.statusCode}");
      print("DEBUG: Update Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'Gagal memperbarui tugas';

      if (response.statusCode == 200 && data['status'] == true) {
        return true;
      } else {
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memperbarui tugas: $e');
    }
  }

  static Future<bool> deleteTugas(String id) async {
    final user = await UserService.getUserLogin();

    if (user == null) {
      throw Exception('User tidak login. Silakan login kembali.');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/delete.php?id=$id&user_id=${user.id}'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return true;
      } else {
        throw Exception(data['message'] ?? 'Gagal menghapus tugas');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus tugas: $e');
    }
  }
}
