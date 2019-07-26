import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:keep_healthy/data/model/work_hours.dart';

abstract class WorkHoursState extends Equatable {
  WorkHoursState([List props = const []]) : super(props);
}

class WorkHoursUninitialized extends WorkHoursState {
  @override
  String toString() {
    return 'WorkHoursUninitialized';
  }
}

class WorkHoursLoaded extends WorkHoursState {
  WorkHours workHours;
  List<int> days;

  WorkHoursLoaded(this.workHours, this.days) : super([workHours, days]);

  @override
  String toString() {
    return 'WorkHoursLoaded ${workHours.startTime}, ${workHours.endTime}, $days';
  }
}
