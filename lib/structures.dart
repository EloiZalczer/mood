import 'package:flutter/material.dart';

class YearMonth implements Comparable<YearMonth> {
  final int year;
  final int month;

  const YearMonth({required this.year, required this.month});

  @override
  bool operator ==(Object other) {
    return other is YearMonth && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() {
    return "YearMonth($year-$month)";
  }

  @override
  int compareTo(YearMonth other) {
    if (year != other.year) return year.compareTo(other.year);
    return month.compareTo(other.month);
  }
}

class NotificationTime {
  final bool enabled;
  final TimeOfDay time;

  const NotificationTime({required this.enabled, required this.time});

  @override
  String toString() {
    return "NotificationTime(${enabled ? "enabled" : "disabled"} at $time)";
  }
}
