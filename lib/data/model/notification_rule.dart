import 'package:equatable/equatable.dart';

class NotificationRule extends Equatable {
  final int id;
  final String ruleName;
  final String notificationTitle;
  final String notificationMessage;
  final int intervalMinutes;

  NotificationRule(
      this.id, this.ruleName, this.notificationTitle, this.notificationMessage, this.intervalMinutes);
}
