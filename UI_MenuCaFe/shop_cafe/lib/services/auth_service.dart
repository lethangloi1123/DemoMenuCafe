import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://10.0.2.2:5296/api/auth"; // Cập nhật baseUrl

  Future<String> login(String emailOrPhone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // Không cần thêm /login vào baseUrl
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"emailOrPhone": emailOrPhone, "password": password}),
    );

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body)['message'];
      } catch (e) {
        throw Exception("Phản hồi không đúng định dạng JSON: ${response.body}");
      }
    } else {
      throw Exception(
        response.body.isNotEmpty ? jsonDecode(response.body)['message'] : "Đã xảy ra lỗi không xác định",
      );
    }
  }

  Future<String> register(String fullName, String email, String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        response.body.isNotEmpty ? jsonDecode(response.body) : "Đã xảy ra lỗi không xác định",
      );
    }
  }
}
