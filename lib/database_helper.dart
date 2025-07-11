import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:planner/main.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calendar_planner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        color INTEGER NOT NULL,
        location TEXT,
        description TEXT,
        is_deleted INTEGER DEFAULT 0
      )
    ''');
  }

  // Create event
  Future<int> insertEvent(MyEvent event) async {
    try {
      final db = await database;
      return await db.insert('events', {
        'title': event.title,
        'start_time': event.start.toIso8601String(),
        'end_time': event.end.toIso8601String(),
        'color': event.color.value,
        'location': event.location,
        'description': event.description,
        'is_deleted': event.isDeleted ? 1 : 0,
      });
    } catch (e) {
      print('DB Insert Error: $e');
      return -1; // or handle as appropriate
    }
  }

  // Read all active events
  Future<List<MyEvent>> getActiveEvents() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'events',
        where: 'is_deleted = ?',
        whereArgs: [0],
      );

      return List.generate(maps.length, (i) {
        return MyEvent(
          id: maps[i]['id'],
          title: maps[i]['title'],
          start: DateTime.parse(maps[i]['start_time']),
          end: DateTime.parse(maps[i]['end_time']),
          color: Color(maps[i]['color']),
          location: maps[i]['location'] ?? '',
          description: maps[i]['description'] ?? '',
          isDeleted: maps[i]['is_deleted'] == 1,
        );
      });
    } catch (e) {
      print('DB Get Active Events Error: $e');
      return [];
    }
  }

  // Read all events (including deleted)
  Future<List<MyEvent>> getAllEvents() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('events');

      return List.generate(maps.length, (i) {
        return MyEvent(
          id: maps[i]['id'],
          title: maps[i]['title'],
          start: DateTime.parse(maps[i]['start_time']),
          end: DateTime.parse(maps[i]['end_time']),
          color: Color(maps[i]['color']),
          location: maps[i]['location'] ?? '',
          description: maps[i]['description'] ?? '',
          isDeleted: maps[i]['is_deleted'] == 1,
        );
      });
    } catch (e) {
      print('DB Get All Events Error: $e');
      return [];
    }
  }

  // Update event
  Future<int> updateEvent(MyEvent event) async {
    final db = await database;
    try {
      return await db.update(
        'events',
        {
          'title': event.title,
          'start_time': event.start.toIso8601String(),
          'end_time': event.end.toIso8601String(),
          'color': event.color.value,
          'location': event.location,
          'description': event.description,
          'is_deleted': event.isDeleted ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [event.id],
      );
    } catch (e) {
      print('DB Update Event Error: $e');
      return -1;
    }
  }

  // Soft delete event
  Future<int> softDeleteEvent(int id) async {
    final db = await database;
    try {
      return await db.update(
        'events',
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('DB Soft Delete Event Error: $e');
      return -1;
    }
  }

  // Restore eventimport 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:planner/main.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calendar_planner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        color INTEGER NOT NULL,
        location TEXT,
        description TEXT,
        is_deleted INTEGER DEFAULT 0
      )
    ''');
  }

  // Create event
  Future<int> insertEvent(MyEvent event) async {
    final db = await database;
    return await db.insert('events', {
      'title': event.title,
      'start_time': event.start.toIso8601String(),
      'end_time': event.end.toIso8601String(),
      'color': event.color.value,
      'location': event.location,
      'description': event.description,
      'is_deleted': event.isDeleted ? 1 : 0,
    });
  }

  // Read all active events
  Future<List<MyEvent>> getActiveEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'is_deleted = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (i) {
      return MyEvent(
        id: maps[i]['id'],
        title: maps[i]['title'],
        start: DateTime.parse(maps[i]['start_time']),
        end: DateTime.parse(maps[i]['end_time']),
        color: Color(maps[i]['color']),
        location: maps[i]['location'] ?? '',
        description: maps[i]['description'] ?? '',
        isDeleted: maps[i]['is_deleted'] == 1,
      );
    });
  }

  // Read all events (including deleted)
  Future<List<MyEvent>> getAllEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return MyEvent(
        id: maps[i]['id'],
        title: maps[i]['title'],
        start: DateTime.parse(maps[i]['start_time']),
        end: DateTime.parse(maps[i]['end_time']),
        color: Color(maps[i]['color']),
        location: maps[i]['location'] ?? '',
        description: maps[i]['description'] ?? '',
        isDeleted: maps[i]['is_deleted'] == 1,
      );
    });
  }

  // Update event
  Future<int> updateEvent(MyEvent event) async {
    final db = await database;
    return await db.update(
      'events',
      {
        'title': event.title,
        'start_time': event.start.toIso8601String(),
        'end_time': event.end.toIso8601String(),
        'color': event.color.value,
        'location': event.location,
        'description': event.description,
        'is_deleted': event.isDeleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // Soft delete event
  Future<int> softDeleteEvent(int id) async {
    final db = await database;
    return await db.update(
      'events',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Restore event
  Future<int> restoreEvent(int id) async {
    final db = await database;
    return await db.update(
      'events',
      {'is_deleted': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hard delete event
  Future<int> hardDeleteEvent(int id) async {
    final db = await database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get events for a specific day
  Future<List<MyEvent>> getEventsForDay(DateTime day) async {
    final db = await database;
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'start_time >= ? AND start_time < ? AND is_deleted = ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String(), 0],
    );

    return List.generate(maps.length, (i) {
      return MyEvent(
        id: maps[i]['id'],
        title: maps[i]['title'],
        start: DateTime.parse(maps[i]['start_time']),
        end: DateTime.parse(maps[i]['end_time']),
        color: Color(maps[i]['color']),
        location: maps[i]['location'] ?? '',
        description: maps[i]['description'] ?? '',
        isDeleted: maps[i]['is_deleted'] == 1,
      );
    });
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 
  Future<int> restoreEvent(int id) async {
    final db = await database;
    try {
      return await db.update(
        'events',
        {'is_deleted': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('DB Restore Event Error: $e');
      return -1;
    }
  }

  // Hard delete event
  Future<int> hardDeleteEvent(int id) async {
    final db = await database;
    try {
      return await db.delete(
        'events',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('DB Hard Delete Event Error: $e');
      return -1;
    }
  }

  // Get events for a specific day
  Future<List<MyEvent>> getEventsForDay(DateTime day) async {
    final db = await database;
    try {
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = startOfDay.add(Duration(days: 1));

      final List<Map<String, dynamic>> maps = await db.query(
        'events',
        where: 'start_time >= ? AND start_time < ? AND is_deleted = ?',
        whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String(), 0],
      );

      return List.generate(maps.length, (i) {
        return MyEvent(
          id: maps[i]['id'],
          title: maps[i]['title'],
          start: DateTime.parse(maps[i]['start_time']),
          end: DateTime.parse(maps[i]['end_time']),
          color: Color(maps[i]['color']),
          location: maps[i]['location'] ?? '',
          description: maps[i]['description'] ?? '',
          isDeleted: maps[i]['is_deleted'] == 1,
        );
      });
    } catch (e) {
      print('DB Get Events For Day Error: $e');
      return [];
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    try {
      await db.close();
    } catch (e) {
      print('DB Close Error: $e');
    }
  }
} 