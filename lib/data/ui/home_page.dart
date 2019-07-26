import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:keep_healthy/data/model/work_hours.dart';
import 'package:keep_healthy/data/ui/work_hours_event.dart';
import 'package:keep_healthy/data/ui/work_hours_state.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import 'work_hours_bloc.dart';

class WorkHoursScreen extends StatefulWidget {
  WorkHoursScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _WorkHoursScreenState();
}

final uninitializedDate = DateTime.parse("2000-01-01 00:00:00Z");
class _WorkHoursScreenState extends State<WorkHoursScreen> {
  final String format = "HH:mm";

  String _formatDate(DateTime dateTime) {
    return DateFormat(format).format(dateTime);
  }

  _getStartDateText(WorkHoursState state) {
    if (state is WorkHoursUninitialized) {
      return _formatDate(uninitializedDate);
    } else if (state is WorkHoursLoaded) {
      return _formatDate(state.workHours.startTime);
    }
  }

  _getEndDateText(WorkHoursState state) {
    if (state is WorkHoursUninitialized) {
      return _formatDate(uninitializedDate);
    } else if (state is WorkHoursLoaded) {
      return _formatDate(state.workHours.endTime);
    }
  }

  DateTime startTime = uninitializedDate;
  DateTime endTime = uninitializedDate;

  @override
  Widget build(BuildContext context) {

    final WorkHoursBloc workHoursBloc = BlocProvider.of(context);

    return BlocBuilder<WorkHoursBloc, WorkHoursState>(
        builder: (blockContext, state) {
          if(state is WorkHoursLoaded) {
            startTime = state.workHours.startTime;
            endTime = state.workHours.endTime;
          }
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Row(
                    children: <Widget>[
                      Text("Start time: "),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showTimePicker(context,
                              onChanged: (date) {
                                startTime = date;
                                workHoursBloc.dispatch(ShowTempWorkHours(WorkHours(startTime, endTime)));
                              });
                        },
                        child: Text(
                          _getStartDateText(state),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("End time: "),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showTimePicker(context,
                              onChanged: (date) {
                                endTime = date;
                                workHoursBloc.dispatch(ShowTempWorkHours(WorkHours(startTime, endTime)));
                              });
                        },
                        child: Text(
                          _getEndDateText(state),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: RaisedButton(
                  onPressed: () {
                    if(startTime != uninitializedDate && endTime != uninitializedDate) {
                      workHoursBloc.dispatch(
                          SaveWorkHours(WorkHours(startTime, endTime)));
                      Toast.show("Work hours saved!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                    }
                  },
                  child: Center(
                    child: Text("Save"),
                  ),
                ),
              )
            ],
          )
      );
    });
  }
}
