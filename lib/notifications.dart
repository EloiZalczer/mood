import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

class NotificationsProvider {
  final StreamController<NotificationResponse> _notificationResponses =
      StreamController<NotificationResponse>.broadcast();

  Stream<NotificationResponse> get notificationResponses =>
      _notificationResponses.stream;

  void addNotificationResponse(NotificationResponse response) {
    print("add notification response");
    _notificationResponses.add(response);
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  static final NotificationsProvider _provider = NotificationsProvider();

  NotificationsProvider get provider => _provider;

  bool _notificationsEnabled = false;

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
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _requestPermissions();

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp == true) {
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

    final bool? grantedNotificationPermission =
        await androidImplementation?.requestNotificationsPermission();
    _notificationsEnabled = grantedNotificationPermission ?? false;
  }

  Future<void> showNotification() async {
    print("show notification");

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          "mood_app",
          "mood_app",
          channelDescription: "channel description",
          importance: Importance.max,
          priority: Priority.high,
          ticker: "ticker",
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "mood_id",
              "Note",
              inputs: <AndroidNotificationActionInput>[
                AndroidNotificationActionInput(
                  choices: ["😀", "🙂", "😐", "🙁", "😞"],
                ),
              ],
            ),
          ],
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationsPlugin.show(
      0,
      "How are you feeling ?",
      "",
      notificationDetails,
      payload: "item x",
    );
  }
}
