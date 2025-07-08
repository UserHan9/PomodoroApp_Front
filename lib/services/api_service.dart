import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

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
      await prefs.setString('username', username); 
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}


//Refresh Token
static Future<bool> refreshAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');

  if (refreshToken == null) {
    print("⛔ Refresh token tidak tersedia.");
    return false;
  }

  final url = Uri.parse("$baseUrl/api/token/refresh/");
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refresh': refreshToken}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    await prefs.setString('access_token', data['access']);
    print("🔄 Access token berhasil diperbarui.");
    return true;
  } else {
    print("❌ Gagal refresh token: ${response.body}");
    return false;
  }
}

//PomodoroSession
static Future<bool> postPomodoroSession({
  required DateTime start,
  required DateTime end,
  required bool success,
}) async {
  Future<http.Response> _makeRequest(String token) {
    final url = Uri.parse("$baseUrl/api/sessions/");
    return http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "start_time": start.toUtc().toIso8601String(),
        "end_time": end.toUtc().toIso8601String(),
        "success": success,
    }),
    );
  }

  final token = await getAccessToken();
  if (token == null) {
    print("⛔ Token tidak tersedia. Harap login ulang.");
    return false;
  }

  var response = await _makeRequest(token);

  if (response.statusCode == 401) {
    print("⚠️ Token expired. Mencoba refresh...");

    final refreshed = await refreshAccessToken();
    if (!refreshed) return false;

    final newToken = await getAccessToken();
    if (newToken == null) return false;

    response = await _makeRequest(newToken);
  }

  if (response.statusCode == 201) {
    print("✅ Pomodoro session berhasil dikirim.");
    return true;
  } else {
    print("❌ Gagal kirim Pomodoro session: ${response.statusCode}");
    print("Response body: ${response.body}");
    return false;
  }
}}