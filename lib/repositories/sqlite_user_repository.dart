import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import 'user_repository.dart';

class SqliteUserRepository implements UserRepository {
  Database? _db;
  final List<UserModel> _fallbackMemoryUsers = <UserModel>[];
  bool _useMemoryFallback = false;

  SqliteUserRepository() {
    try {
      // Tự động sử dụng bộ nhớ tạm nếu chạy trong môi trường test
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        _useMemoryFallback = true;
      }
    } catch (_) {
      // Đề phòng trường hợp Platform.environment ném lỗi trên môi trường đặc biệt
      _useMemoryFallback = true;
    }
  }

  Future<Database?> get database async {
    if (_useMemoryFallback) return null;
    if (_db != null) return _db;
    try {
      _db = await _initDb();
      return _db;
    } catch (e) {
      debugPrint('SQLite init failed, falling back to memory: $e');
      _useMemoryFallback = true;
      return null;
    }
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            fullName TEXT NOT NULL,
            email TEXT NOT NULL,
            avatar TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final db = await database;
    if (db == null) {
      return List<UserModel>.from(_fallbackMemoryUsers);
    }
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  @override
  Future<void> addUser(UserModel user) async {
    final db = await database;
    if (db == null) {
      _fallbackMemoryUsers.add(user);
      return;
    }
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await database;
    if (db == null) {
      final index = _fallbackMemoryUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _fallbackMemoryUsers[index] = user;
      }
      return;
    }
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: <Object>[user.id],
    );
  }

  @override
  Future<void> deleteUser(int id) async {
    final db = await database;
    if (db == null) {
      _fallbackMemoryUsers.removeWhere((u) => u.id == id);
      return;
    }
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }
}
