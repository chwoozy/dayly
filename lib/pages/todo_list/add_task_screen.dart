import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/task_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dayly/components/category_tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/user.dart';
import 'tasks_screen.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _newTaskTitle = '';
  String _taskDescription = '';
  Color _tagColor = Colors.white;
  String _categoryTag = '';
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            height: size.height,
            width: size.width,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .5,
              decoration: BoxDecoration(
                color: primaryBackgroundColor,
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
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Create New Task',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Task Name',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          showCursor: true,
                          decoration: InputDecoration(
                            hintText: 'Add Task Name',
                            errorText:
                                _validate ? 'Please enter a task title' : null,
                          ),
                          cursorColor: Colors.white,
                          autofocus: true,
                          textAlign: TextAlign.left,
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
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Add Description',
                          ),
                          cursorColor: Colors.white,
                          autofocus: true,
                          textAlign: TextAlign.left,
                          onChanged: (newText) {
                            _taskDescription = newText;
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Category',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
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
                                    _categoryTag = 'Work';
                                    _tagColor = Colors.red.shade300;
                                  },
                                ),
                                CategoryTag(
                                  categoryTag: 'Study',
                                  tagColor: Colors.yellow,
                                  onPressCallback: () {
                                    _categoryTag = 'Study';
                                    _tagColor = Colors.yellow;
                                  },
                                ),
                                CategoryTag(
                                  categoryTag: 'Event',
                                  tagColor: Colors.orangeAccent,
                                  onPressCallback: () {
                                    _categoryTag = 'Event';
                                    _tagColor = Colors.orangeAccent;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CategoryTag(
                                  categoryTag: 'LifeStyle',
                                  tagColor: Colors.blueAccent.shade100,
                                  onPressCallback: () {
                                    _categoryTag = 'LifeStyle';
                                    _tagColor = Colors.blueAccent.shade100;
                                  },
                                ),
                                CategoryTag(
                                  categoryTag: 'Miscellaneous',
                                  tagColor: Colors.greenAccent,
                                  onPressCallback: () {
                                    _categoryTag = 'Miscellaneous';
                                    _tagColor = Colors.greenAccent;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                elevation: 0,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  setState(() {
                    _newTaskTitle == '' ? _validate = true : _validate = false;
                  });
                  if (!_validate) {
                    Provider.of<TaskData>(context, listen: false)
                        .addTask(_newTaskTitle, _taskDescription, _tagColor);

                    //Add new task to database
                    await Firestore.instance
                        .collection('task_data')
                        .document(_user.uid)
                        .collection('tasks')
                        .add({
                      'taskName': _newTaskTitle,
                      'taskDescription': _taskDescription,
                      'isDone': false,
                    });

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TasksScreen()));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
