import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_healthy/data/repository/work_hours_repository.dart';
import 'package:keep_healthy/data/ui/work_hours_bloc.dart';
import 'package:keep_healthy/data/ui/work_hours_event.dart';
import 'data/ui/home_page.dart';

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
          child: MyHomePage(
            title: "Keep Healthy",
          ),
        ));
  }
}
