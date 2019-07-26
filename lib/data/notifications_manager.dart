import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/notification_rule.dart';
import 'model/work_hours.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void clearNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void setupDailyNotifications(
      WorkHours workHours, NotificationRule notificationRule) async {
    List<Time> notificationTimes = new List<Time>();

    var notificationTime = workHours.startTime.add(new Duration(minutes: notificationRule.intervalMinutes));

    do {
      var tmp = Time(notificationTime.hour, notificationTime.minute, notificationTime.second);

      notificationTimes.add(tmp);
      notificationTime = notificationTime.add(new Duration(minutes: notificationRule.intervalMinutes));

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
    new AndroidNotificationDetails(notificationRule.id.toString(),
        notificationRule.ruleName, notificationRule.ruleName, icon: "app_icon", largeIcon: "app_icon");
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

}
