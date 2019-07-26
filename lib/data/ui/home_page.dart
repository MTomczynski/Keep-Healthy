import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keep_healthy/data/ui/work_hours_bloc.dart';
import 'package:keep_healthy/data/ui/work_hours_state.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final uninitializedDate = DateTime.parse("2000-01-01 00:00:00Z");

  void _formatDate(DateTime dateTime) {
    String formattedDate = DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<WorkHoursBloc, WorkHoursState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(

            title: Text(widget.title),
          ),
          body: Center(
            child: Text(state.toString()),
          ),
        );
      });
  }
}
