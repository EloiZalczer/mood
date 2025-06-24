import 'package:flutter/material.dart';
import 'package:mood/utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

const _allowEditingKey = 'allow_editing';
const _notificationsEnabledKey = 'notifications_enabled';
const _notificationsTimeKey = 'notifications_time';

class SettingsModel extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsModel._(this._prefs);

  static Future<SettingsModel> load() async {
    return SettingsModel._(await SharedPreferences.getInstance());
  }

  bool get allowEditing => _prefs.getBool(_allowEditingKey) ?? false;

  bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? false;

  TimeOfDay get notificationsTime {
    final value = _prefs.getString(_notificationsTimeKey);

    if (value == null) return TimeOfDay(hour: 23, minute: 00);

    return stringToTimeOfDay(value);
  }

  void update({
    bool? allowEditing,
    bool? notificationsEnabled,
    TimeOfDay? notificationsTime,
  }) {
    bool changed = false;

    if (allowEditing != null && allowEditing != this.allowEditing) {
      _prefs.setBool(_allowEditingKey, allowEditing);
      changed = true;
    }

    if (notificationsEnabled != null &&
        notificationsEnabled != this.notificationsEnabled) {
      _prefs.setBool(_notificationsEnabledKey, notificationsEnabled);
      changed = true;
    }

    if (notificationsTime != null &&
        notificationsTime != this.notificationsTime) {
      _prefs.setString(
        _notificationsTimeKey,
        formatTimeOfDay(notificationsTime),
      );
      changed = true;
    }

    if (changed) notifyListeners();
  }
}
