import 'package:flutter/material.dart';
import 'package:mood/utils.dart';
import 'package:mood/widgets/mood_picker.dart';

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

  @override
  void initState() {
    super.initState();
    _moodController = MoodController();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(datetimeToDate(widget.day)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormField(
              builder: (state) => MoodPicker(controller: _moodController),
              validator: (value) {
                if (_moodController.mood == null) {
                  return ("Please select a mood");
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "Note",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(child: Text("Save"), onPressed: () => _submit()),
      ],
    );
  }
}
