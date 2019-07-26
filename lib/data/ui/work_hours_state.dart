
import 'package:equatable/equatable.dart';
import 'package:keep_healthy/data/model/work_hours.dart';

abstract class WorkHoursState extends Equatable {}

class WorkHoursUninitialized extends WorkHoursState {

  @override
  String toString() {
    return 'WorkHoursUninitialized';
  }
}

class WorkHoursLoaded extends WorkHoursState {

  WorkHours workHours;

  WorkHoursLoaded(this.workHours);

  @override
  String toString() {
    return 'WorkHoursLoaded ${workHours.startTime}, ${workHours.endTime}';
  }
}


