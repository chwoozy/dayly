import 'package:dayly/models/schedulable.dart';
import 'package:dayly/pages/todo_list/ScheduleSummary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  //List<Schedulable> _list = listForScheduling;

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
    double factor = (workingDuration() + 1) / totalDuration;
    for (int i = 0; i < this.widget.listForScheduling.length; i++) {
      this.widget.listForScheduling[i].changeDuration(factor);
    }
  }

  void _compareDuration() {
    _addDuration();
    //print(totalDuration);
    if (totalDuration > workingDuration() + 1) {
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
                  onPressed: () async {
                    _compactDuration();
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ScheduleSummary(
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
        },
      );
    } else {
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

  int workingDuration() {
    return this._endDateTime.difference(_startingDateTime).inMinutes;
  }

  void _addDuration() {
    totalDuration = this.widget.duration;
    for (int i = 0; i < this.widget.listForScheduling.length; i++) {
      if (this.widget.listForScheduling[i].duration == 0) {
        this.widget.listForScheduling[i].duration = _initialDuration.inMinutes;
        totalDuration += _initialDuration.inMinutes;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    height: MediaQuery.of(context).copyWith().size.height / 10,
                    width: MediaQuery.of(context).copyWith().size.width / 4,
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
                    height: MediaQuery.of(context).copyWith().size.height / 10,
                    width: MediaQuery.of(context).copyWith().size.width / 3,
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
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Assumed Duration: ',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '(For task without selected duration) ',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.height / 10,
                width: MediaQuery.of(context).copyWith().size.width / 1.6,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.all(12),
                textColor: Colors.white,
                child: Text('Previous'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.all(12),
                textColor: Colors.white,
                child: Text('Confirm'),
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
    );
  }
}
