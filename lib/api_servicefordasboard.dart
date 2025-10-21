import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//const String API_BASE = "http://127.0.0.1:5000/api/v1";
const String API_BASE = "https://islamicapp-nu.vercel.app/api/v1";

// 🔹 Get Categories
Future<List<dynamic>> getCategories(String token) async {
  final res = await http.get(
    Uri.parse('$API_BASE/category'),
    headers: {"Authorization": "Bearer $token"},
  );
  return jsonDecode(res.body)['data'];
}

// 🔹 Get Islamic Posts
Future<List<dynamic>> getIslamicPosts(String token) async {
  final res = await http.get(
    Uri.parse('$API_BASE/islamic-post'),
    headers: {"Authorization": "Bearer $token"},
  );
  return jsonDecode(res.body)['data'];
}

// 🔹 Create New Islamic Post (with PDF upload)
Future<Map<String, dynamic>> createIslamicPost({
  required String token,
  required String name,
  required String author,
  required String description,
  required String categoryId,
  required File pdfFile,
}) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$API_BASE/islamic-post'),
  );

  request.headers['Authorization'] = 'Bearer $token';

  request.fields['name'] = name;
  request.fields['author'] = author;
  request.fields['description'] = description;
  request.fields['category'] = categoryId;

  request.files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

  var response = await request.send();
  final resBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    return jsonDecode(resBody);
  } else {
    throw Exception("Failed to create post: $resBody");
  }
}
