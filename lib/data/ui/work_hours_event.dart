import 'package:equatable/equatable.dart';
import 'package:keep_healthy/data/model/work_hours.dart';

abstract class WorkHoursEvent extends Equatable {}

class GetWorkHours extends WorkHoursEvent {
  final WorkHours workHours;

  GetWorkHours(this.workHours);

  @override
  String toString() {
    return 'get';
  }
}

class SaveWorkHours extends WorkHoursEvent {
  final WorkHours workHours;

  SaveWorkHours(this.workHours);

  @override
  String toString() {
    return 'save';
  }
}
