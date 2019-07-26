import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:keep_healthy/data/model/work_hours.dart';
import 'package:keep_healthy/data/ui/work_hours_event.dart';
import 'package:keep_healthy/data/ui/work_hours_state.dart';
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

  var weekDaysSet = Set<int>();

  void manageWeekDaysState(bool boolValue, int weekDay) {
    if (boolValue) {
      weekDaysSet.add(weekDay);
    } else {
      weekDaysSet.remove(weekDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WorkHoursBloc workHoursBloc = BlocProvider.of(context);

    Widget checkbox(String title, int day, WorkHoursState state) {
      var isActive;
      if(state is WorkHoursLoaded) {
        isActive = state.days.contains(day);
      } else {
        isActive = false;
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          Checkbox(
            value: isActive,
            onChanged: (bool value) {
              manageWeekDaysState(value, day);
              workHoursBloc.dispatch(ShowTempWorkHours(WorkHours(startTime, endTime), weekDaysSet.toList()));
            },
          )
        ],
      );
    }

    return BlocBuilder<WorkHoursBloc, WorkHoursState>(
        builder: (blockContext, state) {
      if (state is WorkHoursLoaded) {
        startTime = state.workHours.startTime;
        endTime = state.workHours.endTime;
        weekDaysSet = state.days.toSet();
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
                          DatePicker.showTimePicker(context, onChanged: (date) {
                            startTime = date;
                            workHoursBloc.dispatch(ShowTempWorkHours(
                                WorkHours(startTime, endTime),
                                weekDaysSet.toList()));
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
                          DatePicker.showTimePicker(context, onChanged: (date) {
                            endTime = date;
                            workHoursBloc.dispatch(ShowTempWorkHours(
                                WorkHours(startTime, endTime),
                                weekDaysSet.toList()));
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      checkbox("Mon", 1, state),
                      checkbox("Tu", 2, state),
                      checkbox("Wed", 3, state),
                      checkbox("Thur", 4, state),
                      checkbox("Fri", 5, state),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      checkbox("Sat", 6, state),
                      checkbox("Sun", 7, state),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: RaisedButton(
                  onPressed: () {
                    if (startTime != uninitializedDate &&
                        endTime != uninitializedDate) {
                      workHoursBloc.dispatch(SaveWorkHours(
                          WorkHours(startTime, endTime), weekDaysSet.toList()));
                      Toast.show("Work hours saved!", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  },
                  child: Center(
                    child: Text("Save"),
                  ),
                ),
              )
            ],
          ));
    });
  }
}
