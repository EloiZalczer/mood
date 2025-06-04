import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood/app.dart';
import 'package:mood/models.dart';
import 'package:mood/notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();

  final MoodModel model = MoodModel();
  await model.load();

  await NotificationService().init();
  await NotificationService().scheduleNotifications();

  final app = MyApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        Provider<NotificationsProvider>.value(
          value: NotificationService().provider,
        ),
      ],
      child: app,
    ),
  );
}
