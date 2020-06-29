import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:dayly/pages/calendar/event_details.dart';
import 'package:dayly/pages/models/event.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatefulWidget {
  final Event currentEvent;

  const AddEvent({Key key, this.currentEvent}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventFromDate;
  DateTime _eventToDate;
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
    _eventFromDate = DateTime.now();
    _eventToDate = DateTime.now();
    processing = false;
    _errorMsg = '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: Future.value(Provider.of<User>(context)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primaryPurple,
                title: Text(
                    widget.currentEvent != null ? "Edit Event" : "Add Event"),
              ),
              key: _key,
              body: Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: ListTile(
                                leading: Icon(Icons.access_time),
                                title: Text(
                                  "Begins: ${_eventFromDate.day} ${DateFormat('MMMM').format(_eventFromDate)}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                onTap: () async {
                                  DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _eventFromDate,
                                      firstDate:
                                          DateTime(_eventFromDate.year - 5),
                                      lastDate:
                                          DateTime(_eventFromDate.year + 5));
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
                            Flexible(
                              child: ListTile(
                                title: Text(
                                  "Ends: ${_eventToDate.day} ${DateFormat('MMMM').format(_eventToDate)}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                onTap: () async {
                                  DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _eventToDate,
                                      firstDate:
                                          DateTime(_eventToDate.year - 5),
                                      lastDate:
                                          DateTime(_eventToDate.year + 5));
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
                              filled: true,
                              fillColor: Colors.white,
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
                              child: RoundedButton(
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      processing = true;
                                    });
                                    Event _event;
                                    if (widget.currentEvent != null) {
                                      _event = await DatabaseService(
                                              uid: snapshot.data.uid)
                                          .updateEvent(widget.currentEvent);
                                    } else {
                                      _event = Event.newEvent(
                                          _title.text,
                                          _description.text,
                                          _eventFromDate,
                                          _eventToDate);
                                      await DatabaseService(
                                              uid: snapshot.data.uid)
                                          .updateEvent(_event);
                                    }
                                    Navigator.pop(context);
                                    setState(() {
                                      processing = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EventDetails(
                                                  event: _event,
                                                )));
                                  }
                                },
                                text: 'Save',
                                color: primaryPurple,
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

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
