import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository/work_hours_repository.dart';
import 'data/ui/home_page.dart';
import 'data/ui/work_hours_bloc.dart';
import 'data/ui/work_hours_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          builder: (context) =>
              WorkHoursBloc(WorkHoursRepository())..dispatch(GetWorkHours()),
          child: WorkHoursScreen(
            title: "Keep Healthy",
          ),
        ));
  }
}
