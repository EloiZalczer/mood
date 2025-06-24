import 'package:flutter/material.dart';
import 'package:mood/database/moods.dart';
import 'package:mood/models/settings.dart';
import 'package:mood/widgets/mood_form.dart';
import 'package:mood/models/moods.dart';
import 'package:mood/utils.dart';
import 'package:mood/widgets/mood_picker.dart';
import 'package:provider/provider.dart';

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
  final _formKey = GlobalKey<FormState>();
  late MoodController _moodController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _moodController = MoodController(mood: widget.entry.mood);
    _noteController = TextEditingController(text: widget.entry.comment);
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final model = context.read<MoodModel>();
      await model.updateEntry(
        MoodDailyEntry(
          id: widget.entry.id,
          date: widget.entry.date,
          mood: _moodController.mood!,
          comment: _noteController.text,
        ),
      );
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _allowEditing =
        Provider.of<SettingsModel>(context, listen: false).allowEditing;

    return AlertDialog(
      title: Text(datetimeToDate(widget.entry.date)),
      content: MoodForm(
        moodController: _moodController,
        noteController: _noteController,
        formKey: _formKey,
        allowEditing: _allowEditing,
      ),
      actions: [
        TextButton(
          child: Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
        if (_allowEditing)
          ElevatedButton(
            child: Text("Save"),
            onPressed: () => _submit(context),
          ),
      ],
    );
  }
}
