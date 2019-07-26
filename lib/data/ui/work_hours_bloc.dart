import 'package:bloc/bloc.dart';
import 'package:keep_healthy/data/model/notification_rule.dart';
import 'package:keep_healthy/data/repository/work_hours_repository.dart';
import 'package:keep_healthy/data/ui/work_hours_event.dart';
import 'package:keep_healthy/data/ui/work_hours_state.dart';

import '../notifications_manager.dart';

class WorkHoursBloc extends Bloc<WorkHoursEvent, WorkHoursState> {
  final WorkHoursRepository workHoursRepository;
  final NotificationManager notificationManager = NotificationManager();

  WorkHoursBloc(this.workHoursRepository);

  @override
  WorkHoursState get initialState => WorkHoursUninitialized();

  @override
  Stream<WorkHoursState> mapEventToState(WorkHoursEvent event) async* {
    if (event is GetWorkHours) {
      final workHours = await workHoursRepository.getWorkHours();
      if (workHours.startTime == null || workHours.endTime == null) {
        yield WorkHoursUninitialized();
      } else {
        yield WorkHoursLoaded(workHours);
      }
      return;
    } else if (event is SaveWorkHours) {
      await workHoursRepository.saveWorkHours(event.workHours);
      notificationManager.clearNotifications();
      NotificationRule rule =
          NotificationRule(1, "Test rule", "Testing", "Just testing", 1);
      notificationManager.setupDailyNotifications(event.workHours, rule);
      yield WorkHoursLoaded(event.workHours);
      return;
    } else if (event is ShowTempWorkHours) {
      yield WorkHoursLoaded(event.workHours);
      return;
    }
  }
}
