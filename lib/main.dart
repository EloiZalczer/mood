import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood/app.dart';
import 'package:mood/models.dart';
import 'package:mood/notifications.dart';
import 'package:provider/provider.dart';

void main() async {
  final MoodModel model = MoodModel();
  await model.load();

  await NotificationService().init();
  await NotificationService().showNotification();

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
