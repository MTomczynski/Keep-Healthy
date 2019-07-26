import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/notification_rule.dart';
import 'model/work_hours.dart';

initializeLocalNotificationsPlugin() {
  final plugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  plugin.initialize(initializationSettings);
  return plugin;
}

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      initializeLocalNotificationsPlugin();

  void clearNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void setupDailyNotifications(WorkHours workHours,
      NotificationRule notificationRule, List<int> days) async {
    List<Time> notificationTimes = List<Time>();

    var notificationTime = workHours.startTime
        .add(Duration(minutes: notificationRule.intervalMinutes));

    do {
      var tmp = Time(notificationTime.hour, notificationTime.minute,
          notificationTime.second);

      notificationTimes.add(tmp);
      notificationTime = notificationTime
          .add(Duration(minutes: notificationRule.intervalMinutes));
    } while (notificationTime.isBefore(workHours.endTime));

    final platformSpecificRules =
        createPlatformChannelSpecifics(notificationRule);
    days.forEach((day) {
      for (int j = 0; j < notificationTimes.length; j++) {
        final notificationTime = notificationTimes[j];
        setupDailyNotification(j, platformSpecificRules, notificationTime, notificationRule, day);
      }
    });
  }

  void setupDailyNotification(
      int id,
      NotificationDetails platformChannelSpecifics,
      Time time,
      NotificationRule notificationRule,
      int day) async {
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        notificationRule.notificationTitle,
        notificationRule.notificationMessage,
        Day(day),
        time,
        platformChannelSpecifics);
  }

  NotificationDetails createPlatformChannelSpecifics(
      NotificationRule notificationRule) {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "0",
        notificationRule.ruleName,
        notificationRule.ruleName,
        icon: "app_icon",
        largeIcon: "app_icon");
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }
}
