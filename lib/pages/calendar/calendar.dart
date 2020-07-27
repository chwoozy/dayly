import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/calendar/add_event.dart';
import 'package:dayly/pages/calendar/event_details.dart';
import 'package:dayly/pages/calendar/month_view.dart';
import 'package:dayly/services/auth.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final AuthService _authService = AuthService();
  CalendarController _calendarController;

  @override
  void initState() {
    _calendarController = CalendarController();
    _calendarController.displayDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<Event>>(
        future: DatabaseService(uid: _user.uid).allEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                extendBodyBehindAppBar: true,
                floatingActionButton: FloatingActionButton(
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addevent').then((value) {
                      setState(() {});
                    });
                  },
                ),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  leading: IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime dateTime = await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: (size.height * 0.4),
                              child: MonthView(
                                user: _user,
                                selectedDate: _calendarController.displayDate,
                              ),
                            );
                          });
                      if (dateTime != null) {
                        setState(() {
                          _calendarController.displayDate = dateTime;
                        });
                      }
                    },
                  ),
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
                body: SfCalendar(
                  view: CalendarView.week,
                  controller: _calendarController,
                  dataSource: EventDataSource(snapshot.data),
                  viewHeaderStyle: ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                      fontFamily: 'Falling',
                      fontSize: 15,
                    ),
                    dateTextStyle: TextStyle(
                      fontFamily: 'Falling',
                      color: Colors.yellow,
                      fontSize: 18,
                    ),
                  ),
                  headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(
                        fontFamily: 'Falling',
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center),
                  cellBorderColor: Colors.grey[500],
                  timeSlotViewSettings: TimeSlotViewSettings(
                    dateFormat: 'd',
                    dayFormat: 'EEE',
                    timeIntervalHeight: 70,
                    timeTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Falling',
                    ),
                    timeInterval: Duration(minutes: 30),
                    timeFormat: 'HH:mm',
                  ),
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.tealAccent[400], width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  onTap: (CalendarTapDetails details) {
                    List tappedEvent = details.appointments;
                    if (tappedEvent != null) {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EventDetails(event: tappedEvent[0])))
                          .then((value) {
                        setState(() {});
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddEvent(
                                  currentEvent: Event.newEvent(
                                      '',
                                      '',
                                      details.date,
                                      details.date.add(Duration(minutes: 30)),
                                      primaryPurple,
                                      null),
                                  clickAdd: true))).then((value) {
                        setState(() {});
                      });
                    }
                  },
                ));
          } else {
            return Loading();
          }
        });
  }
}
