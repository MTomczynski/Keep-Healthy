import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/notification_rule.dart';
import 'model/work_hours.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void setupDailyNotifications(
      WorkHours workHours, NotificationRule notificationRule) async {
    List<Time> notificationTimes = new List<Time>();
    
    var notificationTime = workHours.startTime.add(Duration(minutes: notificationRule.intervalMinutes));

    do {
      var tmp = Time(notificationTime.hour, notificationTime.minute, notificationTime.second);
      
      notificationTimes.add(tmp);
      notificationTime.add(Duration(minutes: notificationRule.intervalMinutes));

    } while (notificationTime.isBefore(workHours.endTime));
    
    notificationTimes.forEach((notificationTime) =>
        setupDailyNotification(createPlatformChannelSpecifics(notificationRule), notificationTime, notificationRule));
  }

  void setupDailyNotification(NotificationDetails platformChannelSpecifics, Time time, NotificationRule notificationRule) async{
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        notificationRule.id,
        notificationRule.notificationTitle,
        notificationRule.notificationMessage,
        time,
        platformChannelSpecifics);
  }

  NotificationDetails createPlatformChannelSpecifics(NotificationRule notificationRule){
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(notificationRule.id.toString(),
        notificationRule.ruleName, notificationRule.ruleName);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    
    return platformChannelSpecifics;
  }
  
}
