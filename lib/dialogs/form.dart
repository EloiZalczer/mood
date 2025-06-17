import 'package:flutter/material.dart';
import 'package:mood/widgets/mood_picker.dart';

class MoodForm extends StatefulWidget {
  const MoodForm({super.key});

  @override
  State<MoodForm> createState() => _MoodFormState();
}

class _MoodFormState extends State<MoodForm> {
  late MoodController _moodController;
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.key,
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
            controller: _noteController,
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
