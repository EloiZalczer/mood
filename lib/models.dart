import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mood/database.dart';
import 'package:sqflite/sqflite.dart';

class MoodModel extends ChangeNotifier {
  Database? _db;

  List<MoodDailyEntry> _entries = [];

  UnmodifiableListView<MoodDailyEntry> get entries =>
      UnmodifiableListView(_entries);

  Map<Map<String, int>, List<MoodDailyEntry>> get entriesByMonth {
    return groupBy(
      _entries,
      (item) => {"year": item.date.year, "month": item.date.month},
    );
  }

  void addEntry(MoodDailyEntry entry) {
    if (_db == null) return;

    _db!.insert("entries", entry.toRecord());
  }

  void updateEntry(MoodDailyEntry entry) {
    if (_db == null) return;

    _db!.update(
      "entries",
      entry.toRecord(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> load() async {
    _db = await initDB();

    final List<Map<String, Object?>> entriesMap = await _db!.query(
      "entries",
      orderBy: "date",
    );

    final entries = [
      for (final record in entriesMap) MoodDailyEntry.fromRecord(record),
    ];

    _entries = entries;
  }
}
