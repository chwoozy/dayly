import 'package:dayly/components/constants.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dayly/components//tasks_list.dart';
import 'package:dayly/pages/todo_list/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/task_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/components/loading.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _loadingInProgress = false;

  //Obtain task data from Firebase
  @override
  void initState() {
    super.initState();
    User user = Provider.of<User>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user.uid);
    TaskData taskData = Provider.of<TaskData>(context, listen: false);
    databaseService.getTasks(taskData);
    setState(() {
      _loadingInProgress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TaskData tasks = Provider.of<TaskData>(context, listen: true);
    return !_loadingInProgress
        ? Loading()
        : Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  color: primaryBackgroundColor,
                  height: size.height,
                  width: size.width,
                ),
                Container(
                  height: size.height * .30,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5CEB8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            backgroundColor: Colors.red,
                            elevation: 10,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddTaskScreen()));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Glance at your day',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 136,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: <Widget>[
                              CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 5.0,
                                progressColor: Colors.purple,
                                percent: tasks.finishedTaskCount >
                                        tasks.taskCount
                                    ? 1.0
                                    : tasks.finishedTaskCount / tasks.taskCount,
                                center: Text(tasks.taskCount == 0
                                    ? '0%'
                                    : tasks.finishedTaskCount > tasks.taskCount
                                        ? '100%'
                                        : '${(tasks.finishedTaskCount / tasks.taskCount * 100).round()}%'),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Daily Progress',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Text(
                                      '${tasks.finishedTaskCount} / ${tasks.taskCount} Tasks For Today',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TasksList(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
