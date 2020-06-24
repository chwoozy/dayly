import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:dayly/pages/models/task_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dayly/components/category_tag.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String newTaskTitle;
  String taskDescription;
  Color tagColor = Colors.white;
  String categoryTag;

  @override
  Widget build(BuildContext context) {
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
              height: size.height * .55,
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: SingleChildScrollView(
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
                            ),
                            cursorColor: Colors.white,
                            autofocus: true,
                            textAlign: TextAlign.left,
                            onChanged: (newText) {
                              newTaskTitle = newText;
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
                              taskDescription = newText;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  CategoryTag(
                                    categoryTag: 'Work',
                                    tagColor: Colors.red.shade300,
                                    onPressCallback: () {
                                      categoryTag = 'Work';
                                      tagColor = Colors.red.shade300;
                                    },
                                  ),
                                  CategoryTag(
                                    categoryTag: 'Study',
                                    tagColor: Colors.yellow,
                                    onPressCallback: () {
                                      categoryTag = 'Study';
                                      tagColor = Colors.yellow;
                                    },
                                  ),
                                  CategoryTag(
                                    categoryTag: 'Event',
                                    tagColor: Colors.orangeAccent,
                                    onPressCallback: () {
                                      categoryTag = 'Event';
                                      tagColor = Colors.orangeAccent;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  CategoryTag(
                                    categoryTag: 'LifeStyle',
                                    tagColor: Colors.blueAccent.shade100,
                                    onPressCallback: () {
                                      categoryTag = 'LifeStyle';
                                      tagColor = Colors.blueAccent.shade100;
                                    },
                                  ),
                                  CategoryTag(
                                    categoryTag: 'Miscellaneous',
                                    tagColor: Colors.greenAccent,
                                    onPressCallback: () {
                                      categoryTag = 'Miscellaneous';
                                      tagColor = Colors.greenAccent;
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                backgroundColor: Colors.lightBlueAccent,
                elevation: 0,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  print(newTaskTitle);
                  Provider.of<TaskData>(context, listen: false)
                      .addTask(newTaskTitle, taskDescription, tagColor);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
