import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
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
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
        text: widget.currentEvent != null ? widget.currentEvent.title : "");
    _description = TextEditingController(
        text:
            widget.currentEvent != null ? widget.currentEvent.description : "");
    _eventDate = DateTime.now();
    processing = false;
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
                        child: ListTile(
                          leading: Icon(Icons.access_time),
                          title: Align(
                            child: Text(
                                "${_eventDate.day} ${DateFormat('MMMM').format(_eventDate)}"),
                            alignment: Alignment(-1.2, 0),
                          ),
                          onTap: () async {
                            DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: _eventDate,
                                firstDate: DateTime(_eventDate.year - 5),
                                lastDate: DateTime(_eventDate.year + 5));
                            if (picked != null) {
                              setState(() {
                                _eventDate = picked;
                              });
                            }
                          },
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
                                    if (widget.currentEvent != null) {
                                      await DatabaseService(
                                              uid: snapshot.data.uid)
                                          .updateEvent(widget.currentEvent);
                                    } else {
                                      await DatabaseService(
                                              uid: snapshot.data.uid)
                                          .updateEvent(Event.newEvent(
                                              _title.text,
                                              _description.text,
                                              DateTime.now()));
                                    }
                                    Navigator.pop(context);
                                    setState(() {
                                      processing = false;
                                    });
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
