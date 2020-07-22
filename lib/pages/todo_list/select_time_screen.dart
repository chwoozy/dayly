import 'package:dayly/models/schedulable.dart';
import 'package:dayly/pages/todo_list/schedule_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/models/event.dart';
import 'package:provider/provider.dart';
import 'package:dayly/services/database.dart';
import 'package:dayly/components/loading.dart';

class SelectTimeScreen extends StatefulWidget {
  final int duration;
  final List<Schedulable> listForScheduling;

  SelectTimeScreen({@required this.duration, @required this.listForScheduling});

  @override
  _State createState() => _State();
}

class _State extends State<SelectTimeScreen> {
  DateTime _startingDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now();
  Duration _initialDuration = Duration(hours: 0, minutes: 0);
  int totalDuration = 0;
  bool _loading = true;
  List<Event> eventList = [];
  int eventDuration = 0;
  int workingDuration = 0;
  Duration _bufferTime = Duration(hours: 0, minutes: 0);

  void _eventDuration() async {
    final _user = Provider.of<User>(context, listen: false);
    Future<List<Event>> events = DatabaseService(uid: _user.uid).allEvents;
    eventList = await events;
    DateTime todayDate = DateTime.now();
    for (Event i in eventList) {
      if (i.eventFromDate.day == todayDate.day &&
          i.eventFromDate.month == todayDate.month &&
          i.eventFromDate.year == todayDate.year &&
          !i.eventFromDate.isBefore(_startingDateTime)) {
        eventDuration += i.eventToDate.difference(i.eventFromDate).inMinutes;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _eventDuration();
    super.initState();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Notice"),
          content: Text("End Time cannot be earlier than the start time!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _compactDuration() {
    double factor = workingDuration / totalDuration;
    for (int i = 0; i < this.widget.listForScheduling.length; i++) {
      this.widget.listForScheduling[i].changeDuration(factor);
    }
  }

  void _compareDuration() {
    _addDuration();
    _workingDuration();
    workingDuration -= eventDuration;

    if (workingDuration <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Notice"),
            content: Text("You do not have free time for tasks"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (totalDuration > workingDuration) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Notice"),
              content: Text("More time needed to finish these tasks!"),
              actions: <Widget>[
                FlatButton(
                    child: Text('Help Me Compact'),
                    onPressed: () {
                      setState(() {
                        _compactDuration();
                      });
                      //_compactDuration();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        this.context,
                        MaterialPageRoute(
                          builder: (_) => ScheduleSummary(
                            listForScheduling: widget.listForScheduling,
                            startingTime: _startingDateTime,
                            endTime: _endDateTime,
                          ),
                        ),
                      );
                    }),
                // usually buttons at the bottom of the dialog
                FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      //Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ScheduleSummary(
            listForScheduling: widget.listForScheduling,
            startingTime: _startingDateTime,
            endTime: _endDateTime,
          ),
        ),
      );
    }
  }

  void _workingDuration() {
    workingDuration =
        this._endDateTime.difference(_startingDateTime).inMinutes + 1;
  }

  void _addDuration() {
    totalDuration = this.widget.duration;
    for (int i = 0; i < this.widget.listForScheduling.length; i++) {
      if (this.widget.listForScheduling[i].duration == 0) {
        this.widget.listForScheduling[i].duration = _initialDuration.inMinutes;
        totalDuration += _initialDuration.inMinutes;
      }
      this.widget.listForScheduling[i].duration += _bufferTime.inMinutes;
      totalDuration += _bufferTime.inMinutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 16, 0, 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
              ),
              height: MediaQuery.of(context).size.height * .80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Select Time',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.orange,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Start: ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    10,
                            width:
                                MediaQuery.of(context).copyWith().size.width /
                                    4,
                            child: CupertinoDatePicker(
                              use24hFormat: true,
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: _startingDateTime,
                              onDateTimeChanged: (dateTime) {
                                setState(() {
                                  _startingDateTime = dateTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'End: ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    10,
                            width:
                                MediaQuery.of(context).copyWith().size.width /
                                    3,
                            child: CupertinoDatePicker(
                              use24hFormat: true,
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: _endDateTime,
                              onDateTimeChanged: (dateTime) {
                                setState(() {
                                  _endDateTime = dateTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Duration: ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '(For task without duration) ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).copyWith().size.height / 10,
                        width:
                            MediaQuery.of(context).copyWith().size.width / 1.6,
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hm,
                          minuteInterval: 15,
                          secondInterval: 1,
                          initialTimerDuration: _initialDuration,
                          onTimerDurationChanged: (Duration changedTimer) {
                            setState(() {
                              _initialDuration = changedTimer;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Break Time: ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '(Time between each task) ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).copyWith().size.height / 10,
                        width:
                            MediaQuery.of(context).copyWith().size.width / 1.6,
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hm,
                          minuteInterval: 5,
                          secondInterval: 1,
                          initialTimerDuration: _bufferTime,
                          onTimerDurationChanged: (Duration changedTimer) {
                            setState(() {
                              _bufferTime = changedTimer;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        backgroundColor: Color(0xFF3A3E88),
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(18),
//                        ),
//                        padding: EdgeInsets.all(12),
//                        textColor: Colors.white,
                        label: Text('Previous'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Color(0xFF3A3E88),
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(18),
//                        ),
//                        padding: EdgeInsets.all(12),
//                        textColor: Colors.white,
                        label: Text('Confirm'),
                        onPressed: () {
                          _startingDateTime.isAfter(_endDateTime)
                              ? _showDialog()
                              : _compareDuration();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
