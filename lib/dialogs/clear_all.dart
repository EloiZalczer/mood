import 'package:flutter/material.dart';

class ClearAllDialog extends StatelessWidget {
  const ClearAllDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Reset all data?"),
      content: Text(
        "This will clear all your mood entries. This operation cannot be undone. Continue?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
