import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiMotivasi {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<String> getMotivasi() async {
    final response = await http.get(Uri.parse("$baseUrl/api/motivasi/"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['teks']; // atau 'quote' tergantung field
      }
    }
    return "Motivasi tidak tersedia.";
  }
}
