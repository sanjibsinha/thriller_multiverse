import 'package:flutter/material.dart';
import '../services/wp_api.dart';
import 'chapter_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<dynamic>> futureBooks;
  late Future<List<dynamic>> futureChapters; // Add this line

  @override
  void initState() {
    super.initState();
    futureBooks = WpApi.fetchBooks();
    futureChapters = WpApi.fetchChapters(); // Add this line
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Carousel Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'বই এবং ক্লাসিফাইড ফাইল',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD32F2F), // Signature Red
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          // Book Cover Carousel
          SizedBox(
            height: 220, // Adjust height as needed
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

                // Filter out standard uncategorized or internal tags if needed
                final books = snapshot.data!.where((cat) => cat['count'] > 0 && cat['slug'] != 'uncategorized').toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    
                    // Attempt to fetch the ACF image. Fallback to a placeholder if missing.
                    // Note: Ensure your WP backend exposes the ACF field 'bookcover' in the REST API
                    String imageUrl = 'https://via.placeholder.com/150x220/1A1A1A/D32F2F?text=No+Cover';
                    // Check if it exists AND is actually a String before assigning it
                    if (book['acf'] != null && book['acf']['bookcover'] is String) {
                      imageUrl = book['acf']['bookcover'];
                      
                    }

                    return Container(
                      width: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: const Color(0xFF1A1A1A),
                                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            book['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
    );
  }
}