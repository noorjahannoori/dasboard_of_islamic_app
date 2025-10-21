import 'dart:convert';
import 'package:http/http.dart' as http;

const String API_BASE =
    "https://islamicapp-nu.vercel.app/api/v1"; //http://localhost:5000/api/v1/login

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final res = await http.post(
    Uri.parse('$API_BASE/login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception('Login failed: ${res.body}');
  }
}

// Future<List<dynamic>> getCategories(String token) async {
//   final res = await http.get(
//     Uri.parse('$API_BASE/category'),
//     headers: {"Authorization": "Bearer $token"},
//   );
//   return jsonDecode(res.body)['data'];
// }
// 🔹 Get Categories
