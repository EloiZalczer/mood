import 'package:flutter/material.dart';
import 'package:mood/widgets/mood_picker.dart';

class MoodForm extends StatefulWidget {
  final MoodController moodController;
  final TextEditingController noteController;
  final GlobalKey<FormState>? formKey;
  final bool allowEditing;

  const MoodForm({
    super.key,
    required this.moodController,
    required this.noteController,
    this.formKey,
    required this.allowEditing,
  });

  @override
  State<MoodForm> createState() => _MoodFormState();
}

class _MoodFormState extends State<MoodForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormField(
            enabled: widget.allowEditing,
            builder:
                (state) => MoodPicker(
                  controller: widget.moodController,
                  readonly: !widget.allowEditing,
                ),
            validator: (value) {
              if (widget.moodController.mood == null) {
                return ("Please select a mood");
              }
              return null;
            },
          ),
          TextFormField(
            enabled: widget.allowEditing,
            controller: widget.noteController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Note",
            ),
          ),
        ],
      ),
    );
  }
}
