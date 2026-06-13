import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'multiverse_files.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chapters(
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT
      )
    ''');
  }

  // ডেটা ইনসার্ট বা আপডেট করার ফাংশন
  Future<void> cacheChapters(List<dynamic> chapters) async {
    final db = await database;
    Batch batch = db.batch();
    
    for (var chapter in chapters) {
      batch.insert(
        'chapters',
        {
          'id': chapter['id'],
          'title': chapter['title']['rendered'],
          'content': chapter['content']['rendered'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // লোকাল ডেটাবেস থেকে রিড করার ফাংশন
  Future<List<Map<String, dynamic>>> getCachedChapters() async {
    final db = await database;
    return await db.query('chapters', orderBy: 'id DESC');
  }
}