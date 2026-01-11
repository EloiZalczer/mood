import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood/structures.dart';

int daysInMonth(int year, int month) {
  switch (month) {
    case 1 || 3 || 5 || 7 || 8 || 10 || 12:
      return 31;
    case 4 || 6 || 9 || 11:
      return 30;
    case 2:
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) return 29;
      return 28;
    default:
      return 0;
  }
}

Color moodToColor(int mood) {
  switch (mood) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.lime;
    case 4:
      return Colors.green;
    default:
      return Colors.white;
  }
}

List<YearMonth> monthsSince(int year, int month) {
  final currentDate = DateTime.now();
  final currentYear = currentDate.year;
  final currentMonth = currentDate.month;

  if (year == currentYear) {
    return [
      for (var m = month; m <= currentMonth; m++)
        YearMonth(year: currentYear, month: m),
    ];
  }

  final List<YearMonth> monthsSince = [];

  // Add months from the starting year
  for (var m = month; m <= 12; m++) {
    monthsSince.add(YearMonth(year: year, month: m));
  }

  year += 1;

  // Add years inbetween
  while (year < currentYear) {
    monthsSince.addAll([
      for (var m = 1; m <= 12; m++) YearMonth(year: year, month: m),
    ]);
    year += 1;
  }

  // Add months in current year
  for (var m = 1; m <= currentMonth; m++) {
    monthsSince.add(YearMonth(year: currentYear, month: m));
  }

  return monthsSince;
}

String datetimeToDate(DateTime d) {
  return DateFormat("MMMM dd, yyyy").format(d);
}

String formatTimeOfDay(TimeOfDay d) {
  return "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
}

TimeOfDay stringToTimeOfDay(String s) {
  final components = s.split(":");
  return TimeOfDay(
    hour: int.parse(components[0]),
    minute: int.parse(components[1]),
  );
}
