import 'package:dayly/components/constants.dart';
import 'package:dayly/pages/calendar/event_details.dart';
import 'package:dayly/pages/models/event.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:dayly/services/auth.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final AuthService _authService = AuthService();
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<Event> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(event.eventFromDate.year,
          event.eventFromDate.month, event.eventFromDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

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
                List<Event> allEvents = snapshot.data;
                if (allEvents.isNotEmpty) {
                  _events = _groupEvents(allEvents);
                } else {
                  _events = {};
                  _selectedEvents = [];
                }
              } else {
                _events = {};
                _selectedEvents = [];
              }

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TableCalendar(
                      events: _events,
                      initialCalendarFormat: CalendarFormat.week,
                      calendarController: _controller,
                      onDaySelected: (date, events) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        markersColor: primaryPurple,
                        canEventMarkersOverflow: true,
                        selectedColor: Colors.orange,
                        todayColor: Colors.grey,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonShowsNext: false,
                      ),
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    Divider(
                      height: 3.0,
                      thickness: 1.5,
                      color: primaryPurple,
                    ),
                    ..._selectedEvents.map((event) => ListTile(
                          title: Text(event.title),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EventDetails(
                                          event: event,
                                        )));
                          },
                        ))
                  ],
                ),
              );
            }));
  }
}
