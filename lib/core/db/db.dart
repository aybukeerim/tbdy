import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkbuddyai/models/db_model/db_message_model.dart';

class MessageDatabase {
  static Database? _database;
  static final MessageDatabase instance = MessageDatabase._();

  MessageDatabase._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path =
        join((await getApplicationDocumentsDirectory()).path, 'messages.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY,
            sender TEXT,
            receiver TEXT,
            message TEXT,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Message>> getAllMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'],
        sender: maps[i]['sender'],
        receiver: maps[i]['receiver'],
        message: maps[i]['message'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  Future<void> clearAllMessages() async {
    final db = await database;
    await db.delete('messages');
  }
}