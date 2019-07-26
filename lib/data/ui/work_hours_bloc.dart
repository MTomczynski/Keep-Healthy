import 'package:bloc/bloc.dart';
import 'package:keep_healthy/data/repository/work_hours_repository.dart';
import 'package:keep_healthy/data/ui/work_hours_event.dart';
import 'package:keep_healthy/data/ui/work_hours_state.dart';

class WorkHoursBloc extends Bloc<WorkHoursEvent, WorkHoursState> {
  final WorkHoursRepository workHoursRepository;

  WorkHoursBloc(this.workHoursRepository);

  @override
  WorkHoursState get initialState => WorkHoursUninitialized();

  @override
  Stream<WorkHoursState> mapEventToState(WorkHoursEvent event) async* {
    if (event is GetWorkHours) {
      final workHours = await workHoursRepository.getWorkHours();
      yield WorkHoursLoaded(workHours);
      return;
    } else if (event is SaveWorkHours) {
      await workHoursRepository.saveWorkHours(event.workHours);
      yield WorkHoursLoaded(event.workHours);
      return;
    }
  }
}
