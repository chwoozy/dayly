import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/splash_screen.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/calendar/add_event.dart';
import 'package:dayly/pages/calendar/event_details.dart';
import 'package:dayly/pages/calendar/month_view.dart';
import 'package:dayly/services/auth.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final AuthService _authService = AuthService();
  CalendarController _calendarController;
  int _pageState = 0;
  double _windowWidth;
  double _windowHeight;
  double _createWidth;
  double _createHeight;
  double _eventYOffset;
  double _eventXOffset;
  double _createXOffset;
  double _createYOffset;
  bool _isClickAdd = false;
  bool _enableFloating = true;
  bool _keyboardVisible = false;

  Event _currentEvent = Event(
    description: '',
    eid: '',
    eventColor: Colors.grey,
    eventFromDate: DateTime.now(),
    eventToDate: DateTime.now(),
    recurrenceRule: '',
    title: '',
  );

  @override
  void initState() {
    _calendarController = CalendarController();
    _calendarController.displayDate = DateTime.now();
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
      },
    );
  }

  actionableEvent(Event currEvent, int action) {
    if (action == 0) {
      setState(() {
        _currentEvent = currEvent;
        _isClickAdd = false;
        _pageState = 2;
      });
    } else {
      setState(() {
        _pageState = 0;
      });
    }
  }

  actionableEdit(Event currEvent) {
    setState(() {
      _currentEvent = currEvent;
      _pageState = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    Size sizeQuery = MediaQuery.of(context).size;
    _windowWidth = sizeQuery.width;
    _windowHeight = sizeQuery.height;
    _createHeight = _windowHeight - (sizeQuery.height * 0.32);

    switch (_pageState) {
      case 0:
        _eventYOffset = _windowHeight;
        _eventXOffset = 0;
        _createYOffset = _windowHeight;
        _createXOffset = 0;
        _enableFloating = true;
        break;
      case 1:
        _eventYOffset = _keyboardVisible ? 20 : sizeQuery.height * 0.32;
        _eventXOffset = 0;
        _createYOffset = _windowHeight;
        _createXOffset = 0;
        _enableFloating = false;
        break;
      case 2:
        _eventYOffset = _windowHeight;
        _eventXOffset = 0;
        _createYOffset = _keyboardVisible ? 20 : sizeQuery.height * 0.32;
        _createXOffset = 0;
        _enableFloating = false;
        break;
    }

    return FutureBuilder<List<Event>>(
        future: DatabaseService(uid: _user.uid).allEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                floatingActionButton: Visibility(
                  visible: _enableFloating,
                  child: FloatingActionButton(
                    backgroundColor: Colors.indigoAccent[700],
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentEvent = Event.newEvent(
                            '',
                            '',
                            DateTime.now(),
                            DateTime.now().add(Duration(minutes: 30)),
                            primaryPurple,
                            null);
                        _pageState = 2;
                      });
                    },
                  ),
                ),
                // appBar: AppBar(
                //   backgroundColor: Colors.transparent,
                //   elevation: 0.0,
                //   leading: IconButton(
                //     padding: EdgeInsets.symmetric(horizontal: 20.0),
                //     icon: Icon(Icons.calendar_today),
                //     onPressed: () async {
                //       DateTime dateTime = await showModalBottomSheet(
                //           context: context,
                //           builder: (BuildContext builder) {
                //             return Container(
                //               height: (size.height * 0.4),
                //               child: MonthView(
                //                 user: _user,
                //                 selectedDate: _calendarController.displayDate,
                //               ),
                //             );
                //           });
                //       if (dateTime != null) {
                //         setState(() {
                //           _calendarController.displayDate = dateTime;
                //         });
                //       }
                //     },
                //   ),
                //   actions: <Widget>[
                //     IconButton(
                //       padding: EdgeInsets.symmetric(horizontal: 20.0),
                //       icon: Icon(Icons.exit_to_app),
                //       onPressed: () async {
                //         await _authService.signOutGoogle();
                //       },
                //     )
                //   ],
                // ),
                body: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (_pageState != 0) {
                          setState(() {
                            _pageState = 0;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        absorbing: _pageState != 0,
                        child: SfCalendar(
                          view: CalendarView.week,
                          controller: _calendarController,
                          todayHighlightColor: Colors.indigoAccent,
                          dataSource: EventDataSource(snapshot.data),
                          viewHeaderStyle: ViewHeaderStyle(
                            dayTextStyle: TextStyle(
                              fontFamily: 'Falling',
                              fontSize: 15,
                            ),
                            dateTextStyle: TextStyle(
                              fontFamily: 'Falling',
                              color: Colors.yellow,
                              fontSize: 15,
                            ),
                          ),
                          headerStyle: CalendarHeaderStyle(
                              textStyle: TextStyle(
                                fontFamily: 'Falling',
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center),
                          cellBorderColor: Colors.grey[500],
                          timeSlotViewSettings: TimeSlotViewSettings(
                            dateFormat: 'd',
                            dayFormat: 'EEE',
                            timeIntervalHeight: 50,
                            timeTextStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Falling',
                            ),
                            timeInterval: Duration(minutes: 30),
                            timeFormat: 'HH:mm',
                          ),
                          selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Colors.indigoAccent, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          onTap: (CalendarTapDetails details) async {
                            List tappedEvent = details.appointments;
                            if (details.targetElement ==
                                    CalendarElement.calendarCell ||
                                details.targetElement ==
                                    CalendarElement.appointment) {
                              if (tappedEvent != null) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => EventDetails(
                                //             event: tappedEvent[0]))).then((value) {
                                //   setState(() {});
                                // });
                                setState(() {
                                  _currentEvent = tappedEvent[0];
                                  _pageState = 1;
                                });
                              } else {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => AddEvent(
                                //             currentEvent: Event.newEvent(
                                //                 '',
                                //                 '',
                                //                 details.date,
                                //                 details.date
                                //                     .add(Duration(minutes: 30)),
                                //                 primaryPurple,
                                //                 null),
                                //             clickAdd: true))).then((value) {
                                //   setState(() {});
                                // });
                                setState(() {
                                  _currentEvent = Event.newEvent(
                                      '',
                                      '',
                                      details.date,
                                      details.date.add(Duration(minutes: 30)),
                                      primaryPurple,
                                      null);
                                  _isClickAdd = true;
                                  _pageState = 2;
                                });
                              }
                            } else if (details.targetElement ==
                                CalendarElement.header) {
                              DateTime dateTime = await showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext builder) {
                                    return Container(
                                      height: (sizeQuery.height * 0.4),
                                      child: MonthView(
                                        user: _user,
                                        selectedDate:
                                            _calendarController.displayDate,
                                      ),
                                    );
                                  });
                              if (dateTime != null) {
                                setState(() {
                                  _calendarController.displayDate = dateTime;
                                });
                              }
                            } else if (details.targetElement ==
                                CalendarElement.viewHeader) {}
                          },
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      padding: EdgeInsets.all(32),
                      height: _windowHeight,
                      width: _windowWidth,
                      duration: Duration(
                        milliseconds: 1000,
                      ),
                      curve: Curves.fastLinearToSlowEaseIn,
                      transform: Matrix4.translationValues(
                          _eventXOffset, _eventYOffset, 1),
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: EventDetails(
                        event: _currentEvent,
                        actionable: actionableEvent,
                      ),
                    ),
                    AnimatedContainer(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      height: _createHeight,
                      width: _windowWidth,
                      duration: Duration(
                        milliseconds: 1000,
                      ),
                      curve: Curves.fastLinearToSlowEaseIn,
                      transform: Matrix4.translationValues(
                          _createXOffset, _createYOffset, 1),
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: AddEvent(
                        key: ValueKey(_currentEvent.eid),
                        currentEvent: _currentEvent,
                        clickAdd: _isClickAdd,
                        actionable: actionableEdit,
                      ),
                    ),
                  ],
                ));
          } else {
            return SplashScreen();
          }
        });
  }
}
