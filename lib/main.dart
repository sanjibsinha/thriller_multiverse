import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'screens/library_screen.dart';
import 'screens/support_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

// Handles notifications when the app is completely closed or running in the background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Background message ID: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for Desktop testing (Linux/Windows/macOS)
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize Firebase ONLY on mobile platforms
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Boot the system
  runApp(const ThrillerApp()); 
}

// Ensure your existing ThrillerApp class remains here below this code.

class ThrillerApp extends StatelessWidget {
  const ThrillerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thriller Multiverse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'TiroBangla',
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep Black
        primaryColor: const Color(0xFFD32F2F), // Signature Red
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A), // Terminal Gray
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD32F2F),
          secondary: Color(0xFFD32F2F),
          surface: Color(0xFF1A1A1A),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFFD32F2F),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const BaseLayout(),
    );
  }
}

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  
  int _selectedIndex = 0;

  // Placeholder for our future screens
  static const List<Widget> _widgetOptions = <Widget>[
    LibraryScreen(),
    SupportScreen(), // The newly created support screen
    Center(child: Text('ডেটাবেস ফেচ করা হচ্ছে...', style: TextStyle(color: Colors.grey, fontSize: 18))),
    Center(child: Text('সাপোর্ট ও ডোনেশন পেজ', style: TextStyle(color: Colors.grey, fontSize: 18))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('থ্রিলার মাল্টিভার্স'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Future Drawer Menu
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Future Notifications
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'লাইব্রেরি',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'সাপোর্ট',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}