import 'package:dayly/models/schedulable.dart';
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

  final topAppBar = AppBar(
    elevation: 0.1,
    //backgroundColor: Color.fromRGBO(64, 75, 96, .9),
    backgroundColor: Color(0xFF3A3E88),
    title: Text('Summary'),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.list),
        onPressed: () {},
      )
    ],
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
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEventByDate();
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(oldIndex, newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final schedulable = widget.listForScheduling.removeAt(oldIndex);
        widget.listForScheduling.insert(newIndex, schedulable);
      });
    }

    return Scaffold(
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: _loading
          ? Loading()
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(28)),
                    padding: EdgeInsets.all(16),
                    //decoration: ,
                    child: Text(
                      'Here is a summary for your schedule, drag the item to change the schedule!',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ReorderableListView(
                      onReorder: _onReorder,
                      scrollDirection: Axis.vertical,
                      children: List.generate(widget.listForScheduling.length,
                          (index) {
                        return SchedulableTile(
                            schedule: widget.listForScheduling[index],
                            key: ValueKey(index));
                      })),
                ),
              ],
            ),
    );
  }
}
