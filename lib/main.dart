import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood/app.dart';
import 'package:mood/models/moods.dart';
import 'package:mood/models/settings.dart';
import 'package:mood/notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  tz.initializeTimeZones();
  var location = tz.getLocation("Europe/Paris");
  tz.setLocalLocation(location);

  final MoodModel moodModel = MoodModel();
  await moodModel.load();

  final SettingsModel settingsModel = await SettingsModel.load();

  await NotificationService().init();

  settingsModel.addListener(() {
    if (!settingsModel.notificationsEnabled) {
      NotificationService().cancelNotifications();
    } else {
      NotificationService().scheduleNotifications(
        settingsModel.notificationsTime,
      );
    }
  });

  final app = MyApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: moodModel),
        Provider<NotificationsProvider>.value(
          value: NotificationService().provider,
        ),
        ChangeNotifierProvider.value(value: settingsModel),
      ],
      child: app,
    ),
  );
}
