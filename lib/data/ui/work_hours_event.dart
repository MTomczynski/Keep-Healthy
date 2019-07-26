import 'package:equatable/equatable.dart';
import 'package:keep_healthy/data/model/work_hours.dart';

abstract class WorkHoursEvent extends Equatable {}

class GetWorkHours extends WorkHoursEvent {

  @override
  String toString() {
    return 'get';
  }
}

class ShowTempWorkHours extends WorkHoursEvent {
  final WorkHours workHours;
  final List<int> days;

  ShowTempWorkHours(this.workHours, this.days);

  @override
  String toString() {
    return 'temp ${workHours.startTime}, ${workHours.endTime}, $days';
  }
}

class SaveWorkHours extends WorkHoursEvent {
  final WorkHours workHours;
  final List<int> days;

  SaveWorkHours(this.workHours, this.days);

  @override
  String toString() {
    return 'save';
  }
}
