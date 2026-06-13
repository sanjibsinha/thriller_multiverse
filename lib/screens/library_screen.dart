import 'package:flutter/material.dart';
import '../services/wp_api.dart';
import 'chapter_screen.dart';
import 'book_chapters_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<dynamic>> futureBooks;
  late Future<List<dynamic>> futureChapters;

  @override
  void initState() {
    super.initState();
    futureBooks = WpApi.fetchBooks();
    futureChapters = WpApi.fetchChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Books Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'বই এবং ক্লাসিফাইড ফাইল',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Books Carousel
            SizedBox(
              height: 250,
              child: FutureBuilder<List<dynamic>>(
                future: futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.grey)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('কোনো ডেটাবেস এন্ট্রি পাওয়া যায়নি।', style: TextStyle(color: Colors.grey)));
                  }

                  final books = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      
                      String? imageUrl;
                      // Safety check for raw image URL
                      if (book['acf'] != null && book['acf']['bookcover'] is String) {
                        imageUrl = book['acf']['bookcover'];
                      }

                      return GestureDetector(
                        onTap: () {
                          // Navigate to Category/Book Chapters
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookChaptersScreen(
                                categoryId: book['id'],
                                bookTitle: book['name'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    color: const Color(0xFF1A1A1A),
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => 
                                                const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                                          )
                                        : const Icon(Icons.image, color: Colors.grey, size: 50),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                book['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Chapters Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'লেটেস্ট ক্রাইম ফাইল',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F), 
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Chapters List
            FutureBuilder<List<dynamic>>(
              future: futureChapters,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F))),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.grey)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('কোনো ডেটাবেস এন্ট্রি পাওয়া যায়নি।', style: TextStyle(color: Colors.grey)));
                }

                final chapters = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    
                    // Clean the HTML title string WordPress sends
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
                        leading: const Icon(Icons.article, color: Color(0xFFD32F2F), size: 30),
                        title: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                        onTap: () {
                          // Navigate to Reading Screen
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
            const SizedBox(height: 30), // Bottom padding
          ],
        ),
      ),
    );
  }
}