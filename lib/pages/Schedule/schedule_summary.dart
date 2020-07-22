import 'package:dayly/models/schedulable.dart';
import 'package:dayly/pages/Schedule/schedule_screen.dart';
import 'package:dayly/pages/Schedule/toschedule.dart';
import 'package:dayly/pages/todo_list/tasks_screen.dart';
import 'package:dayly/services/schedule_manager.dart';
import 'package:dayly/services/sort_manager.dart';
import 'package:flutter/material.dart';
import 'package:dayly/components/schedulable_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dayly/services/database.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/components/loading.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleSummary extends StatefulWidget {
  final List<Schedulable> listForScheduling;
  final DateTime startingTime;
  final DateTime endTime;
  final SortManager sortManager = SortManager();

  ScheduleSummary({
    @required this.listForScheduling,
    @required this.startingTime,
    @required this.endTime,
  });

  @override
  _ScheduleSummaryState createState() => _ScheduleSummaryState();
}

class _ScheduleSummaryState extends State<ScheduleSummary> {
  List<Event> eventList = [];
  DateTime todayDate = DateTime.now();
  bool _loading = true;
  List<Schedulable> finalResult = [];
  //List<Schedulable> listForBuffer = [];

  Widget topAppBar(BuildContext context) => AppBar(
        elevation: 0.1,
        //backgroundColor: Color.fromRGBO(64, 75, 96, .9),
        //backgroundColor: Color(0xFF3A3E88),
        title: Text('Summary'),
      );

  Schedulable _eventToSchedulable(Event event) {
    return Schedulable(
        name: event.title,
        description: event.description,
        category: 'Event',
        priorityScore: 1,
        toBeScheduled: true,
        dateTime: event.eventFromDate,
        endTime: event.eventToDate,
        duration: event.eventToDate.difference(event.eventFromDate).inMinutes);
  }

  void _getEventByDate() async {
    final _user = Provider.of<User>(context, listen: false);
    Future<List<Event>> events = DatabaseService(uid: _user.uid).allEvents;
    eventList = await events;
    DateTime todayDate = DateTime.now();
    for (int i = 0; i < eventList.length; i++) {
      if (eventList[i].eventToDate.day == todayDate.day &&
          eventList[i].eventToDate.month == todayDate.month &&
          eventList[i].eventToDate.year == todayDate.year) {
        widget.listForScheduling.add(_eventToSchedulable(eventList[i]));
      }
    }
    widget.sortManager.sort(widget.listForScheduling);
    for (int i = 0; i < widget.listForScheduling.length; i++) {
      print(widget.listForScheduling[i].name);
      print(widget.listForScheduling[i].duration);
    }
    final ScheduleManager scheduleManager = ScheduleManager(
        startingTime: this.widget.startingTime,
        endTime: this.widget.endTime,
        listForScheduling: this.widget.listForScheduling);
    finalResult = scheduleManager.schedule();
    for (Schedulable item in finalResult) {
      print(item.dateTime.toString() + item.name);
    }
    setState(() {
      _loading = false;
    });
  }

//  void _addBuffer(Schedulable event) {
//    Event bufferEvent = Event(
//        title: 'Buffer',
//        description: 'Buffer',
//        eventFromDate: event.dateTime.subtract(Duration(minutes: 30)),
//        eventToDate: event.endTime);
//    widget.listForScheduling.add(_eventToSchedulable(bufferEvent));
//    widget.sortManager.sort(widget.listForScheduling);
//    print(widget.listForScheduling.length);
//    final ScheduleManager scheduleManager = ScheduleManager(
//        startingTime: this.widget.startingTime,
//        endTime: this.widget.endTime,
//        listForScheduling: this.widget.listForScheduling);
//    //finalResult = scheduleManager.schedule();
//    setState(() {
//      finalResult = scheduleManager.schedule();
//    });
//  }

  @override
  void initState() {
    super.initState();
    _getEventByDate();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: _user.uid);

    void _onReorder(oldIndex, newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final schedulable = finalResult.removeAt(oldIndex);
        finalResult.insert(newIndex, schedulable);
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        //backgroundColor: Color(0xFF3A3E88),
        onPressed: () async {
          //Navigator.pop(context);
          await databaseService.deleteSchedule();
          for (Schedulable i in this.finalResult) {
            await Firestore.instance
                .collection('task_data')
                .document(_user.uid)
                .collection('schedule')
                .add({
              'name': i.name,
              'description': i.description,
              'isDone': i.isDone,
              'toBeScheduled': i.toBeScheduled,
              'priorityScore': i.priorityScore,
              'duration': i.duration,
              'tag': i.tag,
              'dateTime': i.dateTime,
              'category': i.category,
              'endTime': i.endTime,
            });
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScheduleScreen()),
          );
        },
        label: Text("Confirm"),
      ),
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar(context),
      body: _loading
          ? Loading()
          : Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(28)),
                        padding: EdgeInsets.all(16),
                        //decoration: ,
                        child: Text(
                          'Here is a summary for your schedule, drag the item to change the schedule!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReorderableListView(
                          onReorder: _onReorder,
                          scrollDirection: Axis.vertical,
                          children: List.generate(finalResult.length, (index) {
                            return SchedulableTile(
                              schedule: finalResult[index],
                              key: ValueKey(index),
                            );
                          })),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
