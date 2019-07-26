import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/notification_rule.dart';
import 'model/work_hours.dart';


initializeLocalNotificationsPlugin() {
  final plugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  plugin.initialize(initializationSettings);
  return plugin;
}

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = initializeLocalNotificationsPlugin();

  void clearNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void setupDailyNotifications(
      WorkHours workHours, NotificationRule notificationRule) async {
    List<Time> notificationTimes = List<Time>();

    var notificationTime = workHours.startTime.add(Duration(minutes: notificationRule.intervalMinutes));

    do {
      var tmp = Time(notificationTime.hour, notificationTime.minute, notificationTime.second);

      notificationTimes.add(tmp);
      notificationTime = notificationTime.add(Duration(minutes: notificationRule.intervalMinutes));

    } while (notificationTime.isBefore(workHours.endTime));

    final platformSpecificRules = createPlatformChannelSpecifics(notificationRule);
    for(int i = 0; i < notificationTimes.length; i++) {
      final notificationTime = notificationTimes[i];
      setupDailyNotification(i, platformSpecificRules, notificationTime, notificationRule);
    }
  }

  void setupDailyNotification(int id, NotificationDetails platformChannelSpecifics, Time time, NotificationRule notificationRule) async{
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        notificationRule.notificationTitle,
        notificationRule.notificationMessage,
        time,
        platformChannelSpecifics);
  }

  NotificationDetails createPlatformChannelSpecifics(NotificationRule notificationRule){
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(notificationRule.id.toString(),
        notificationRule.ruleName, notificationRule.ruleName, icon: "app_icon", largeIcon: "app_icon");
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

}
