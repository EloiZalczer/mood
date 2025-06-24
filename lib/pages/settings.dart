import 'package:flutter/material.dart';
import 'package:mood/dialogs/clear_all.dart';
import 'package:mood/models/moods.dart';
import 'package:mood/models/settings.dart';
import 'package:mood/structures.dart';
import 'package:mood/widgets/checkbox_field.dart';
import 'package:mood/widgets/notification_time_field.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SettingsModel _model;

  void _onResetAllData(BuildContext context) async {
    final model = Provider.of<MoodModel>(context, listen: false);

    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => ClearAllDialog(),
    );

    if (confirm == true) model.clearAll();
  }

  void _submit() {
    _formKey.currentState!.save();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _model = Provider.of<SettingsModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _submit();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              CheckboxFormField(
                title: Text("Allow editing"),
                initialValue: _model.allowEditing,
                onSaved: (value) {
                  _model.update(allowEditing: value);
                },
              ),
              NotificationTimeFormField(
                title: Text("Daily notifications"),
                initialValue: NotificationTime(
                  enabled: _model.notificationsEnabled,
                  time: _model.notificationsTime,
                ),
                onSaved: (value) {
                  _model.update(
                    notificationsTime: value!.time,
                    notificationsEnabled: value.enabled,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onResetAllData(context);
                  },
                  child: Text("Reset all data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
