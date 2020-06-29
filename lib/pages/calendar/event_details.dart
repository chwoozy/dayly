import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:dayly/models/event.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  const EventDetails({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              event.title,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "${event.eventDate.day} ${DateFormat("MMMM").format(event.eventDate)} ${DateFormat("y").format(event.eventDate)}",
            ),
            SizedBox(height: 20.0),
            Text(event.description)
          ],
        ),
      ),
    );
  }
}
