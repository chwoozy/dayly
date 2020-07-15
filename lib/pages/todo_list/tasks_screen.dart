import 'package:dayly/components/constants.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:dayly/pages/todo_list/select_time_screen.dart';
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
import 'package:dayly/components/floating_button.dart';
import 'package:flutter/cupertino.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _loadingInProgress = true;
  List<Schedulable> _selectedTask = [];
  List<Schedulable> _listForScheduling = [];
  int _totalDuration = 0;

  int getTotalDuration(List<Schedulable> selectedTasks) {
    int result = 0;
    for (int i = 0; i < selectedTasks.length; i++) {
      if (selectedTasks != null &&
          selectedTasks[i].toBeScheduled &&
          selectedTasks[i].duration != null) {
        result += selectedTasks[i].duration;
      }
    }
    return result;
  }

  List<Schedulable> getSelectedTasks(List<Schedulable> selectedTasks) {
    List<Schedulable> _selectedTask = [];
    for (int i = 0; i < selectedTasks.length; i++) {
      if (selectedTasks != null && selectedTasks[i].toBeScheduled) {
        _selectedTask.add(selectedTasks[i]);
      }
    }
    return _selectedTask;
  }

  void _taskEditModalBottomSheet(
      BuildContext context, List<Schedulable> listForScheduling) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(22),
            topLeft: Radius.circular(22),
          ),
        ),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
            ),
            height: MediaQuery.of(context).size.height * .50,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Select Task For Scheduling',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
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
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listForScheduling.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemBuilder: (context, index) {
                        final schedulable = listForScheduling[index];
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border:
                                Border.all(style: BorderStyle.solid, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return ListTile(
                                title: Text(
                                  schedulable.name,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  'Duration: ' +
                                      getDuration(schedulable.duration),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                trailing: Checkbox(
                                  value: schedulable.toBeScheduled,
                                  onChanged: (checkboxState) {
                                    setState(() {
                                      schedulable.toggleScheduling();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  RaisedButton(
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.all(12),
                    textColor: Colors.white,
                    child: Text('Next'),
                    onPressed: () async {
                      _totalDuration = getTotalDuration(listForScheduling);
                      _selectedTask = getSelectedTasks(listForScheduling);
                      //print(_totalDuration);
                      Navigator.pop(context);
                      await showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(22),
                              topLeft: Radius.circular(22),
                            ),
                          ),
                          builder: (context) => SelectTimeScreen(
                                duration: _totalDuration,
                                listForScheduling: _selectedTask,
                              ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String getDuration(int duration) {
    if (duration != null) {
      String hours = (duration / 60).toStringAsFixed(1);
      return hours + ' h';
    } else {
      return ' None ';
    }
  }

  void _getTaskData() async {
    User user = Provider.of<User>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user.uid);
    TaskData taskData = Provider.of<TaskData>(context, listen: false);
    await databaseService.getTasks(taskData);
    setState(() {
      _loadingInProgress = false;
    });
  }

  //Obtain task data from Firebase
  @override
  void initState() {
    super.initState();
    _getTaskData();
//    User user = Provider.of<User>(context, listen: false);
//    DatabaseService databaseService = DatabaseService(uid: user.uid);
//    TaskData taskData = Provider.of<TaskData>(context, listen: false);
//    databaseService.getTasks(taskData);
//    setState(() {
//      _loadingInProgress = false;
//    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TaskData tasks = Provider.of<TaskData>(context, listen: true);
    _listForScheduling = tasks.toSchedule();
    //_selectedTask = [];
    return _loadingInProgress
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
                        Row(
                          children: <Widget>[
                            FloatingButton(
                              icon: Icons.date_range,
                              tag: 'btn1',
                              onPressCallback: () {
                                _taskEditModalBottomSheet(
                                    context, _listForScheduling);
                              },
                            ),
                            Spacer(),
                            FloatingButton(
                              icon: Icons.add,
                              tag: 'btn2',
                              onPressCallback: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddTaskScreen()));
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Glance at your day',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          height: 120,
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
