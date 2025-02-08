import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static NotificationService notificationService = NotificationService._();

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.notification.request();
    PermissionStatus alarmStatus =
        await Permission.scheduleExactAlarm.request();

    if (status.isDenied && alarmStatus.isDenied) {
      await requestPermission();
    }
  }

  Future<void> initNotification() async {
    await requestPermission();

    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iOS = const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await plugin
        .initialize(initializationSettings)
        .then(
          (value) => log("Notification Init Done...."),
        )
        .onError(
          (error, _) => log("Error : $error"),
        );
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      '101',
      'My Chat App',
      priority: Priority.high,
      importance: Importance.max,
      color: Colors.red,
      sound: RawResourceAndroidNotificationSound('sound2'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      DateTime.now().microsecond,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      '101',
      'My Chat App',
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('sound2'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.zonedSchedule(
      01,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showPeriodicNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      '101',
      'My Chat App',
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('sound1'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.periodicallyShow(
      1,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String url,
  }) async {
    http.Response res = await http.get(Uri.parse(url));

    Directory direcory = await getApplicationSupportDirectory();

    File file = File("${direcory.path}/img.png");

    file.writeAsBytesSync(res.bodyBytes);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      '101',
      'My Chat App',
      priority: Priority.high,
      importance: Importance.max,
      largeIcon: FilePathAndroidBitmap(file.path),
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(file.path),
      ),
      sound: const RawResourceAndroidNotificationSound('sound2'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(18, title, body, notificationDetails);
  }
}

/*
1. Add flutter_local_notifications package
2. Setup AndroidManifest.xml  (Add Permission)
  - build.gradle (app level)
3. Init Notification
  - Notification Object
4. Show Simple Notification
5. Show Scheduled Notification
6. Show Periodic Notification
7. Show Big Picture Notification
*/
//
