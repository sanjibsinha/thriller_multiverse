import 'dart:convert';
import 'package:http/http.dart' as http;
import 'db_helper.dart'; // লোকাল ডেটাবেস ইম্পোর্ট

class WpApi {
  static const String baseUrl = 'https://sanjibdebsinha.in/wp-json/wp/v2';
  static final dbHelper = DatabaseHelper();

  // Fetch Chapters with Offline Support
  static Future<List<dynamic>> fetchChapters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts?_embed'));

      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        // ব্যাকগ্রাউন্ডে ডেটাবেস সিঙ্ক
        await dbHelper.cacheChapters(fetchedData);
        return fetchedData;
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      // নেটওয়ার্ক ফেল করলে লোকাল স্টোরেজ থেকে ডেটা সার্ভ হবে
      final localData = await dbHelper.getCachedChapters();
      
      if (localData.isNotEmpty) {
        // UI-এর সাথে মানানসই করতে ফরম্যাট রি-স্ট্রাকচার করা হলো
        return localData.map((row) => {
          'id': row['id'],
          'title': {'rendered': row['title']},
          'content': {'rendered': row['content']},
        }).toList();
      } else {
        throw Exception('নো সিগন্যাল। লোকাল ডেটাবেস এম্পটি।');
      }
    }
  }

  static Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books. Code: ${response.statusCode}');
    }
  }

  // Fetch chapters belonging to a specific category/book
  static Future<List<dynamic>> fetchChaptersByCategory(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts?categories=$categoryId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      throw Exception('নেটওয়ার্ক কানেকশন নেই। এই ক্যাটাগরির ফাইল লোড করতে ইন্টারনেট প্রয়োজন।');
    }
  }
}