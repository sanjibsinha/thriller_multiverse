import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ChapterScreen extends StatelessWidget {
  final String title;
  final String contentHtml;

  const ChapterScreen({
    super.key,
    required this.title,
    required this.contentHtml,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep Black
      appBar: AppBar(
        title: const Text('ক্লাসিফাইড ফাইল'),
        backgroundColor: const Color(0xFF1A1A1A), // Terminal Gray
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD32F2F), // Signature Red
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFF2C2C2C), thickness: 1.5),
            const SizedBox(height: 20),
            
            // HTML Content Body
            Html(
              data: contentHtml,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontFamily: 'TiroBangla',
                  fontSize: FontSize(18.0),
                  lineHeight: const LineHeight(1.8),
                  color: const Color(0xFFE0E0E0), // Soft white/gray for reading
                ),
                "p": Style(
                  margin: Margins.only(bottom: 20.0),
                ),
                "blockquote": Style(
                  backgroundColor: const Color(0xFF1A1A1A),
                  border: const Border(left: BorderSide(color: Color(0xFFD32F2F), width: 4)),
                  padding: HtmlPaddings.all(15.0),
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[400],
                ),
                "a": Style(
                  color: const Color(0xFFD32F2F),
                  textDecoration: TextDecoration.none,
                ),
              },
            ),
            
            const SizedBox(height: 40),
            // End of File Marker
            const Center(
              child: Text(
                '--- EOF (END OF FILE) ---',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Courier', // Terminal style font
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}