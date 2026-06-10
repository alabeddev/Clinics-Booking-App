import 'package:clinics_booking/models/booking.dart';
import 'package:clinics_booking/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:clinics_booking/models/notification.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('clinic_booking.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE bookings (
    id TEXT PRIMARY KEY,
    userId TEXT NOT NULL,
    doctorId TEXT NOT NULL,
    date TEXT NOT NULL,
    status TEXT NOT NULL,
    price INTEGER NOT NULL,
    notes TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE users (
    id TEXT PRIMARY KEY,
    uname TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT NOT NULL 
    )
    ''');

    await db.execute('''
    CREATE TABLE notifications (
    id TEXT PRIMARY KEY,
    userId TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    createdAt TEXT NOT NULL
    )
    ''');
  }

  Future<void> insertUser(UserModel user) async {
    final db = await instance.database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser(String uid) async {
    final db = await instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [uid]);

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertBooking(BookingModel booking) async {
    final db = await instance.database;

    await db.insert(
      'bookings',
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BookingModel>> getUserBookings(String uid) async {
    final db = await instance.database;
    final result = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [uid],
    );

    return result.map((json) => BookingModel.fromMap(json)).toList();
  }

  Future<int> updateBookingStatus(String bookingId, String newStatus) async {
    final db = await instance.database;

    return await db.update(
      'bookings',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future<int> deleteBooking(String id) async {
    final db = await instance.database;

    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertNotification(NotificationModel notification) async {
    final db = await instance.database;

    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotificationModel>> getUserNotifications(String uid) async {
    final db = await instance.database;
    final result = await db.query(
      'notifications',
      where: 'userId = ?',
      whereArgs: [uid],
      orderBy: 'createdAt DESC',
    );

    return result.map((json) => NotificationModel.fromMap(json)).toList();
  }

  Future<int> deleteNotification(String id) async {
    final db = await instance.database;
    return await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  /* Future close() async {
    final db = await instance.database;
    db.close();
  } */
}
