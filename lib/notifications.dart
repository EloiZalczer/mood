import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mood/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsProvider {
  final StreamController<MoodNotificationResponse> _notificationResponses =
      StreamController<MoodNotificationResponse>();

  Stream<MoodNotificationResponse> get notificationResponses =>
      _notificationResponses.stream;

  void addNotificationResponse(NotificationResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    final notificationTime = prefs.getString("notifications_time");

    if (notificationTime == null) {
      _notificationResponses.add(
        MoodNotificationResponse(
          effectiveDate: DateTime.now(),
          response: response,
        ),
      );
    } else {
      final notifTime = stringToTimeOfDay(notificationTime);
      final now = TimeOfDay.fromDateTime(DateTime.now());

      if (now.isBefore(notifTime)) {
        _notificationResponses.add(
          MoodNotificationResponse(
            effectiveDate: DateTime.now().subtract(const Duration(days: 1)),
            response: response,
          ),
        );
      } else {
        _notificationResponses.add(
          MoodNotificationResponse(
            effectiveDate: DateTime.now(),
            response: response,
          ),
        );
      }
    }
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  static final NotificationsProvider _provider = NotificationsProvider();

  NotificationsProvider get provider => _provider;

  late NotificationAppLaunchDetails? appLaunchDetails;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _provider.addNotificationResponse,
    );

    await _requestPermissions();

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    appLaunchDetails = notificationAppLaunchDetails;

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      final response = notificationAppLaunchDetails.notificationResponse;

      if (response != null) _provider.addNotificationResponse(response);
    }
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  Future<void> cancelNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleNotifications(TimeOfDay time) async {
    // FIXME probably shouldn't cancel and re-schedule notifications every time
    await _notificationsPlugin.cancelAll();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      "How are you feeling ?",
      "Keep track of your mood now !",
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "daily_mood_channel_id",
          "daily mood channel name",
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showNotification() async {
    await _notificationsPlugin.show(
      0,
      "How are you feeling ?",
      "",
      NotificationDetails(
        android: AndroidNotificationDetails(
          "daily_mood_channel_id",
          "daily mood channel name",
        ),
      ),
    );
  }
}

class MoodNotificationResponse {
  final DateTime effectiveDate;
  final NotificationResponse response;

  MoodNotificationResponse({
    required this.effectiveDate,
    required this.response,
  });
}
