import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mood/database.dart';
import 'package:mood/structures.dart';
import 'package:sqflite/sqflite.dart';

class MoodModel extends ChangeNotifier {
  Database? _db;

  List<MoodDailyEntry> _entries = [];

  UnmodifiableListView<MoodDailyEntry> get entries =>
      UnmodifiableListView(_entries);

  Map<YearMonth, List<MoodDailyEntry>> get entriesByMonth {
    return groupBy(
      _entries,
      (item) => YearMonth(year: item.date.year, month: item.date.month),
    );
  }

  Future<void> addEntry(MoodDailyEntry entry) async {
    print("add entry");
    print(_db);

    if (_db == null) return;

    int id = await _db!.insert("entries", entry.toRecord());

    final entries = await _db!.query(
      "entries",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    _entries.add(MoodDailyEntry.fromRecord(entries[0]));

    print(entries);
    notifyListeners();
  }

  MoodDailyEntry? getEntry(DateTime day) {
    try {
      return _entries.firstWhere((elem) => elem.date == day);
    } on StateError {
      return null;
    }
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

    print({"year": 2025, "month": 6}.hashCode);
    print({"year": 2025, "month": 6}.hashCode);

    print(entries);

    _entries = entries;
  }
}
