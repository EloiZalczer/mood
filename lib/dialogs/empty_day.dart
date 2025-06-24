import 'package:flutter/material.dart';
import 'package:mood/database/moods.dart';
import 'package:mood/widgets/mood_form.dart';
import 'package:mood/models/moods.dart';
import 'package:mood/utils.dart';
import 'package:mood/widgets/mood_picker.dart';
import 'package:provider/provider.dart';

class EmptyDayDialog extends StatefulWidget {
  final DateTime day;

  const EmptyDayDialog({super.key, required this.day});

  static void show(BuildContext context, DateTime day) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return EmptyDayDialog(day: day);
      },
    );
  }

  @override
  State<EmptyDayDialog> createState() => _EmptyDayDialogState();
}

class _EmptyDayDialogState extends State<EmptyDayDialog> {
  final _formKey = GlobalKey<FormState>();
  late MoodController _moodController;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _moodController = MoodController();
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final model = context.read<MoodModel>();
      await model.addEntry(
        MoodDailyEntry(
          date: widget.day,
          mood: _moodController.mood!,
          comment: _noteController.text,
        ),
      );
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(datetimeToDate(widget.day)),
      content: MoodForm(
        moodController: _moodController,
        noteController: _noteController,
        formKey: _formKey,
        allowEditing: true,
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(child: Text("Save"), onPressed: () => _submit(context)),
      ],
    );
  }
}
