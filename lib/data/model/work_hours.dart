import 'package:equatable/equatable.dart';

class WorkHours extends Equatable{
  final DateTime startTime;
  final DateTime endTime;

  WorkHours(this.startTime, this.endTime): super([startTime, endTime]);

}