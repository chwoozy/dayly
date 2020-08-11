import 'package:dayly/components/loading.dart';
import 'package:dayly/models/notification_manager.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dayly/components/primary_button.dart';

class AddEvent extends StatefulWidget {
  final Event currentEvent;
  final bool clickAdd;
  final Function actionable;

  const AddEvent({
    Key key,
    this.currentEvent,
    this.clickAdd,
    @required this.actionable,
  }) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventFromDate;
  DateTime _eventToDate;
  Color _eventColor;
  String _recurrenceRule;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  String _errorMsg;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
        text: widget.currentEvent != null ? widget.currentEvent.title : "");
    _description = TextEditingController(
        text:
            widget.currentEvent != null ? widget.currentEvent.description : "");
    _eventFromDate = widget.currentEvent != null
        ? widget.currentEvent.eventFromDate
        : DateTime.now();
    _eventToDate = widget.currentEvent != null
        ? widget.currentEvent.eventToDate
        : DateTime.now().add(Duration(minutes: 30));
    _eventColor = const Color(0xFF0F8644);
    _recurrenceRule =
        widget.currentEvent != null ? widget.currentEvent.recurrenceRule : null;
    processing = false;
    _errorMsg = '';
    notificationManager
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationManager.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    Size sizeQuery = MediaQuery.of(context).size;

    return FutureBuilder<User>(
        future: Future.value(Provider.of<User>(context)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.grey[900],
              key: _key,
              body: Form(
                key: _formKey,
                child: Container(
                  height: sizeQuery.height * 0.68,
                  alignment: Alignment.center,
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Text(
                          widget.currentEvent == null
                              ? "Add Event"
                              : widget.clickAdd == true
                                  ? "Add Event"
                                  : "Edit Event",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: sizeQuery.width * 0.28,
                              child: ListTile(
                                title: Text(
                                  "${_eventFromDate.day} ${DateFormat('MMMM').format(_eventFromDate)}\n${DateFormat('jm').format(_eventFromDate)}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                onTap: () async {
                                  DateTime picked;
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height /
                                              3,
                                          child: CupertinoDatePicker(
                                            initialDateTime: _eventFromDate,
                                            onDateTimeChanged: (dateTime) {
                                              setState(() {
                                                picked = dateTime;
                                              });
                                            },
                                            minuteInterval: 1,
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                          ),
                                        );
                                      });
                                  if (picked != null) {
                                    if (_eventToDate.isBefore(picked)) {
                                      setState(() {
                                        _eventFromDate = picked;
                                        _eventToDate = picked;
                                      });
                                    } else {
                                      setState(() {
                                        _eventFromDate = picked;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Icon(Icons.arrow_right),
                            Container(
                              width: sizeQuery.width * 0.28,
                              child: ListTile(
                                title: Text(
                                  "${_eventToDate.day} ${DateFormat('MMMM').format(_eventToDate)}\n${DateFormat('jm').format(_eventToDate)}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                onTap: () async {
                                  DateTime picked;
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height /
                                              3,
                                          child: CupertinoDatePicker(
                                            initialDateTime: _eventToDate,
                                            onDateTimeChanged: (dateTime) {
                                              setState(() {
                                                picked = dateTime;
                                              });
                                            },
                                            minuteInterval: 1,
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                          ),
                                        );
                                      });
                                  if (picked != null) {
                                    if (picked.isBefore(_eventFromDate)) {
                                      setState(() {
                                        _errorMsg = 'Invalid dates selected!';
                                      });
                                    } else {
                                      setState(() {
                                        _eventToDate = picked;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _title,
                          validator: (value) => (value.isEmpty)
                              ? "Please enter an event title"
                              : null,
                          decoration: InputDecoration(
                              labelText: "Event Title",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _description,
                          minLines: 3,
                          maxLines: 5,
                          validator: (value) => (value.isEmpty)
                              ? "Please enter event description"
                              : null,
                          decoration: InputDecoration(
                              labelText: "Event Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          _errorMsg,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      processing
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: PrimaryButton(
                                title: widget.clickAdd == true
                                    ? "Create Event"
                                    : "Save Changes",
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      processing = true;
                                    });
                                    Event _event;
                                    if (widget.currentEvent != null) {
                                      _event = Event(
                                        eid: widget.currentEvent.eid,
                                        title: _title.text,
                                        description: _description.text,
                                        eventFromDate: _eventFromDate,
                                        eventToDate: _eventToDate,
                                        eventColor: _eventColor,
                                        recurrenceRule: _recurrenceRule,
                                      );
                                    } else {
                                      _event = Event.newEvent(
                                        _title.text,
                                        _description.text,
                                        _eventFromDate,
                                        _eventToDate,
                                        _eventColor,
                                        _recurrenceRule,
                                      );
                                    }
                                    await DatabaseService(
                                            uid: snapshot.data.uid)
                                        .updateEvent(_event);
                                    await notificationManager
                                        .scheduleNotification(_event);
                                    setState(() {
                                      processing = false;
                                    });
                                    widget.actionable(_event);
                                  }
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
