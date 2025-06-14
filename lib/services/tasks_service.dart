import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unitime/models/tasks_model.dart';

class TugasService {
  static const String baseUrl = 'https://aftlah.my.id/api-moprog/tugas';

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

  static Future<TugasModel> fetchTugasById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/detail.php?id=$id'));

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return TugasModel.fromJson(jsonBody['data']);
      } else {
        throw Exception(
            'Gagal mengambil detail tugas (Kode: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil tugas: $e');
    }
  }

  static Future<bool> createTugas(TugasModel tugas) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tugas.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat membuat tugas: $e');
    }
  }

  static Future<bool> updateTugas(String id, TugasModel tugas) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          ...tugas.toJson(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memperbarui tugas: $e');
    }
  }

  static Future<bool> deleteTugas(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus tugas: $e');
    }
  }
}
