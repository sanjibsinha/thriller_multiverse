import 'package:flutter/material.dart';
import '../services/wp_api.dart';
import 'chapter_screen.dart';

class BookChaptersScreen extends StatefulWidget {
  final int categoryId;
  final String bookTitle;

  const BookChaptersScreen({
    super.key,
    required this.categoryId,
    required this.bookTitle,
  });

  @override
  State<BookChaptersScreen> createState() => _BookChaptersScreenState();
}

class _BookChaptersScreenState extends State<BookChaptersScreen> {
  late Future<List<dynamic>> futureChapters;

  @override
  void initState() {
    super.initState();
    futureChapters = WpApi.fetchChaptersByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text(widget.bookTitle),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureChapters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.grey)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('এই বইয়ের অধীনে কোনো ফাইল পাওয়া যায়নি।', style: TextStyle(color: Colors.grey)));
          }

          final chapters = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              
              String title = chapter['title']['rendered']
                  .replaceAll('&#8211;', '-')
                  .replaceAll('&#8217;', "'");

              return Card(
                color: const Color(0xFF1A1A1A),
                margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: const BorderSide(color: Color(0xFF2C2C2C), width: 1),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15.0),
                  leading: const Icon(Icons.insert_drive_file, color: Color(0xFFD32F2F), size: 28),
                  title: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                  onTap: () {
                    // Reuse our existing ChapterScreen to read!
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterScreen(
                          title: title,
                          contentHtml: chapter['content']['rendered'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}