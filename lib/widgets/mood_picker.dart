import 'package:flutter/material.dart';
import 'package:mood/utils.dart';

class MoodPicker extends StatefulWidget {
  final Function? onChanged;
  final MoodController? controller;

  final bool readonly;

  const MoodPicker({
    super.key,
    this.onChanged,
    this.controller,
    this.readonly = false,
  });

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  int? selected;

  late MoodController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? MoodController();

    controller.addListener(() {
      setState(() {});
    });
  }

  Color iconColor(int mood) {
    if (controller.mood == null || controller.mood == mood) {
      return moodToColor(mood);
    }
    return Colors.grey;
  }

  ButtonStyle buttonStyle(int mood) {
    if (controller.mood == mood) {
      return ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade500),
      );
    }
    return ButtonStyle();
  }

  void _changeMood(int mood) {
    if (!widget.readonly) {
      controller.changeMood(mood);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: IconButton(
            onPressed: () => _changeMood(4),
            style: buttonStyle(4),
            icon: Icon(Icons.sentiment_very_satisfied, color: iconColor(4)),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => _changeMood(3),
            style: buttonStyle(3),
            icon: Icon(Icons.sentiment_satisfied, color: iconColor(3)),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => _changeMood(2),
            style: buttonStyle(2),
            icon: Icon(Icons.sentiment_neutral, color: iconColor(2)),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => _changeMood(1),
            style: buttonStyle(1),
            icon: Icon(Icons.sentiment_dissatisfied, color: iconColor(1)),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () => _changeMood(0),
            style: buttonStyle(0),
            icon: Icon(Icons.sentiment_very_dissatisfied, color: iconColor(0)),
          ),
        ),
      ],
    );
  }
}

class MoodController extends ChangeNotifier {
  int? mood;

  MoodController({this.mood});

  changeMood(int mood) {
    this.mood = mood;
    notifyListeners();
  }
}
