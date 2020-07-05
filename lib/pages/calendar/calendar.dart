import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/calendar/event_details.dart';
import 'package:dayly/services/auth.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final AuthService _authService = AuthService();
  // CalendarController _controller;
  // Map<DateTime, List<dynamic>> _events;
  // List<dynamic> _selectedEvents;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = CalendarController();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // Map<DateTime, List<dynamic>> _groupEvents(List<Event> allEvents) {
  //   Map<DateTime, List<dynamic>> data = {};
  //   allEvents.forEach((event) {
  //     DateTime date = DateTime(event.eventFromDate.year,
  //         event.eventFromDate.month, event.eventFromDate.day, 12);
  //     if (data[date] == null) data[date] = [];
  //     data[date].add(event);
  //   });
  //   return data;
  // }

  // List<Event> _getDataSource() {
  //   List<Event> currEvent = <Event>[];
  //   final DateTime today = DateTime.now();
  //   final DateTime startTime =
  //       DateTime(today.year, today.month, today.day, 9, 0, 0);
  //   final DateTime endTime = startTime.add(const Duration(hours: 2));
  //   currEvent.add(
  //       Event('Conference', startTime, endTime, const Color(0xFF0F8644), false));
  //   return currEvent;
  // }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);

    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryPurple,
          onPressed: () {
            Navigator.pushNamed(context, '/addevent').then((value) {
              setState(() {});
            });
          },
          label: Text("Add Event"),
        ),
        appBar: AppBar(
          title: Text('Calendar'),
          backgroundColor: primaryPurple,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await _authService.signOutGoogle();
              },
            )
          ],
        ),
        body: FutureBuilder<List<Event>>(
            future: DatabaseService(uid: _user.uid).allEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SfCalendar(
                  view: CalendarView.day,
                  dataSource: EventDataSource(snapshot.data),
                  todayHighlightColor: primaryPurple,
                  cellBorderColor: Colors.grey[500],
                  backgroundColor: primaryBackgroundColor,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeIntervalHeight: 70,
                  ),
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: primaryPurple, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  onTap: (CalendarTapDetails details) {
                    List tappedEvent = details.appointments;
                    if (tappedEvent != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  EventDetails(event: tappedEvent[0])));
                    }
                  },
                  // monthViewSettings: MonthViewSettings(
                  //   appointmentDisplayMode:
                  //       MonthAppointmentDisplayMode.appointment,
                  // ),
                );
              } else {
                return Loading();
              }
            }));
  }
}
