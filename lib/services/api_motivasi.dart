import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/model/models_motivasi.dart'; // ✅ Lokasi yang kamu pakai


class ApiMotivasi {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<List<Motivasi>> getMotivasi() async {
    final response = await http.get(Uri.parse("$baseUrl/api/motivasi/"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((json) => Motivasi.fromJson(json)).toList();
      }
    }

    // Jika gagal atau kosong
    return [];
  }
}
