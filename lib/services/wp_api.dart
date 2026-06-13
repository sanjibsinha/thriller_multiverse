import 'dart:convert';
import 'package:http/http.dart' as http;

class WpApi {
  // Your central database URL
  static const String baseUrl = 'https://sanjibdebsinha.in/wp-json/wp/v2';

  // Fetch all posts (chapters)
  static Future<List<dynamic>> fetchChapters() async {
    final response = await http.get(Uri.parse('$baseUrl/posts?_embed'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load database. Code: ${response.statusCode}');
    }
  }

  // Fetch all categories (books)
  static Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books. Code: ${response.statusCode}');
    }
  }
}