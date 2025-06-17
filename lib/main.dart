import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood/app.dart';
import 'package:mood/models.dart';
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

  final MoodModel model = MoodModel();
  await model.load();

  await NotificationService().init();
  await NotificationService().scheduleNotifications();

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
