import 'package:dayly/components/constants.dart';
import 'package:dayly/components/slider_widget.dart';
import 'package:dayly/models/priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/task_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dayly/components/category_tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/user.dart';
import 'tasks_screen.dart';
import 'package:flutter/cupertino.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _newTaskTitle = '';
  String _taskDescription = '';
  Color _tagColor;
  String _tag = '';
  bool _validate = false;
  int _priorityScore;
  Duration _initialTimer = Duration(hours: 0, minutes: 0);
  Priority priorityData = Priority(
    priorityLevel: 'Normal',
    priorityScore: 40,
  );

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text('New Task'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              setState(() {
                _newTaskTitle == '' ? _validate = true : _validate = false;
                _priorityScore = priorityData.priorityScore;
              });

              if (!_validate) {
                Provider.of<TaskData>(context, listen: false).addTask(
                    _newTaskTitle,
                    _taskDescription,
                    _tag,
                    _priorityScore,
                    _initialTimer.inMinutes);

                //Add new task to database
                await Firestore.instance
                    .collection('task_data')
                    .document(_user.uid)
                    .collection('tasks')
                    .add({
                  'taskName': _newTaskTitle,
                  'taskDescription': _taskDescription,
                  'isDone': false,
                  'tag': _tag,
                  'priorityScore': _priorityScore,
                  'duration': _initialTimer.inMinutes,
                });

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TasksScreen()));
              }
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(size.height * 0.03),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Category',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CategoryTag(
                                  categoryTag: 'Work',
                                  tagColor: Colors.red.shade300,
                                  onPressCallback: () {
                                    _tag = 'Work';
                                    _tagColor = Colors.red.shade300;
                                  },
                                ),
                                CategoryTag(
                                  categoryTag: 'Study',
                                  tagColor: Colors.yellow,
                                  onPressCallback: () {
                                    _tag = 'Study';
                                    _tagColor = Colors.yellow;
                                  },
                                ),
                                CategoryTag(
                                  categoryTag: 'Event',
                                  tagColor: Colors.orangeAccent,
                                  onPressCallback: () {
                                    _tag = 'Event';
                                    _tagColor = Colors.orangeAccent;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CategoryTag(
                                  categoryTag: 'LifeStyle',
                                  tagColor: Colors.blueAccent.shade100,
                                  onPressCallback: () {
                                    _tag = 'LifeStyle';
                                    _tagColor = Colors.blueAccent.shade100;
                                  },
                                ),
                                CategoryTag(
                                  categoryTag: 'Miscellaneous',
                                  tagColor: Colors.greenAccent,
                                  onPressCallback: () {
                                    _tag = 'Miscellaneous';
                                    _tagColor = Colors.greenAccent;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Priority',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        SliderWidget(
                          priorityData: priorityData,
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Duration',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * .1,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: EdgeInsets.all(12),
                              textColor: Colors.white,
                              child: Text(
                                _initialTimer.compareTo(
                                            Duration(hours: 0, minutes: 0)) ==
                                        1
                                    ? _initialTimer.inHours.toString() +
                                        "h " +
                                        (_initialTimer.inMinutes -
                                                _initialTimer.inHours * 60)
                                            .toString() +
                                        'min'
                                    : "Add Duration",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              //color: Color(0xFF3A3E88),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext builder) {
                                      return Container(
                                        padding: EdgeInsets.only(top: 20),
                                        height: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height /
                                            3,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * .2,
                                                ),
                                                Center(
                                                  child: Text(
                                                    'Duration',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * .08,
                                                ),
                                                RaisedButton(
                                                  //color: Color(0xFF3A3E88),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                  padding: EdgeInsets.all(12),
                                                  textColor: Colors.white,
                                                  child: Text('Done'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                            CupertinoTheme(
                                              data: CupertinoThemeData(
                                                  textTheme:
                                                      CupertinoTextThemeData(
                                                          pickerTextStyle:
                                                              TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ))),
                                              child: CupertinoTimerPicker(
                                                mode:
                                                    CupertinoTimerPickerMode.hm,
                                                minuteInterval: 1,
                                                secondInterval: 1,
                                                initialTimerDuration:
                                                    _initialTimer,
                                                onTimerDurationChanged:
                                                    (Duration changedTimer) {
                                                  setState(() {
                                                    _initialTimer =
                                                        changedTimer;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              height: size.height * .55,
              decoration: BoxDecoration(
                //color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Task Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textInputAction: TextInputAction.done,
                          showCursor: true,
                          decoration: InputDecoration(
                            hintText: 'Add Task Name',
                            errorText:
                                _validate ? 'Please enter a task title' : null,
                          ),
                          cursorColor: Colors.white,
                          //autofocus: true,
                          textAlign: TextAlign.left,
                          onSubmitted: (value) {
                            FocusNode().unfocus();
                          },
                          onChanged: (newText) {
                            _newTaskTitle = newText;
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Task Description',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Add Description',
                          ),
                          cursorColor: Colors.white,
                          autofocus: false,
                          textAlign: TextAlign.left,
                          onSubmitted: (value) {
                            FocusNode().unfocus();
                          },
                          onChanged: (newText) {
                            _taskDescription = newText;
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
