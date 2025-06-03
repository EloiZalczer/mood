import 'package:flutter/material.dart';
import 'package:mood/database.dart';
import 'package:mood/utils.dart';

class ShowEntryDialog extends StatefulWidget {
  final MoodDailyEntry entry;

  const ShowEntryDialog({super.key, required this.entry});

  static void show(BuildContext context, MoodDailyEntry entry) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return ShowEntryDialog(entry: entry);
      },
    );
  }

  @override
  State<ShowEntryDialog> createState() => _ShowEntryDialogState();
}

class _ShowEntryDialogState extends State<ShowEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(datetimeToDate(widget.entry.date))
    );
  }
}