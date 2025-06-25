import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  /// Login dan kembalikan `true` jika sukses
  static Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/api/token/");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      print("✅ Login berhasil!");
      return true;
    } else {
      final body = jsonDecode(response.body);
      print("❌ Login gagal: ${body['detail']}");
      return false;
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<bool> postPomodoroSession({
    required DateTime start,
    required DateTime end,
    required bool success,
  }) async {
    final token = await getAccessToken();
    final url = Uri.parse("$baseUrl/api/sessions/");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "user": 1,
        "start_time": start.toUtc().toIso8601String(),
        "end_time": end.toUtc().toIso8601String(),
        "success": success,
      }),
    );

    if (response.statusCode == 201) {
      print("✅ Pomodoro session terkirim!");
      return true;
    } else {
      print("❌ Gagal kirim session: ${response.statusCode}");
      print("Detail: ${response.body}");
      return false;
    }
  }
}
