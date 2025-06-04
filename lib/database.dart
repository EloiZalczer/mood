import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MoodDailyEntry {
  final int? id;
  final DateTime date;
  final int mood;
  final String? comment;

  const MoodDailyEntry({
    this.id,
    required this.date,
    required this.mood,
    this.comment,
  });

  factory MoodDailyEntry.fromRecord(Map<String, Object?> record) {
    return MoodDailyEntry(
      id: record["id"] as int,
      date: DateTime.parse(record["date"] as String),
      mood: record["mood"] as int,
      comment: record["comment"] as String?,
    );
  }

  Map<String, Object?> toRecord() {
    return {
      "id": id,
      "date": DateFormat("yyyy-MM-dd").format(date),
      "mood": mood,
      "comment": comment,
    };
  }

  @override
  String toString() {
    return "MoodDailyEntry(id=$id, date=$date, mood=$mood, comment=$comment)";
  }
}

Future<Database> initDB() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'mood_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE entries(id INTEGER PRIMARY KEY, date STRING UNIQUE, mood INTEGER, comment TEXT)",
      );
    },
    version: 1,
  );

  return database;
}
