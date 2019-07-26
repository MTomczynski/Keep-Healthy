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
        yield WorkHoursLoaded(workHours, List());
      }
      return;
    } else if (event is SaveWorkHours) {
      await workHoursRepository.saveWorkHours(event.workHours);
      notificationManager.clearNotifications();
      notificationManager.setupDailyNotifications(event.workHours, oneHourRestRule, event.days);
      yield WorkHoursLoaded(event.workHours, event.days);
      return;
    } else if (event is ShowTempWorkHours) {
      yield WorkHoursLoaded(event.workHours, event.days);
      return;
    }
  }
}

final oneHourRestRule = NotificationRule("Rest", "Odejdź od biurka", "Zrób sobie 5 minutową przerwę. Zmień pozycję ciała oraz nie wykonuj czynności obciążających wzrok", 60);
