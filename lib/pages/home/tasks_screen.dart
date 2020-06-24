import 'package:flutter/material.dart';
import 'package:dayly/components//tasks_list.dart';
import 'package:dayly/pages/home/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:dayly/pages/models/task_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TaskData tasks = Provider.of<TaskData>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: <Widget>[
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          percent: tasks.finishedTaskCount / tasks.taskCount,
                          center: Text(tasks.taskCount == 0
                              ? '0%'
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
