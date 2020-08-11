import 'package:dayly/models/user.dart';
import 'package:dayly/pages/calendar/add_event.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dayly/models/event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  final Function actionable;

  const EventDetails({Key key, @required this.event, @required this.actionable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    Size sizeQuery = MediaQuery.of(context).size;
    int _executeAction;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: AppBar(
      //   title: Text('Event Details'),
      //   actions: <Widget>[
      //     FlatButton(
      //       child: Icon(
      //         Icons.create,
      //         color: primaryBackgroundColor,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context);
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (_) => AddEvent(currentEvent: event)));
      //       },
      //     ),
      //     FlatButton(
      //       child: Icon(
      //         Icons.delete,
      //         color: primaryBackgroundColor,
      //       ),
      //       onPressed: () async {
      //         await DatabaseService(uid: _user.uid).deleteEvent(event);
      //         Navigator.pop(context);
      //       },
      //     )
      //   ],
      // ),
      body: Container(
        width: sizeQuery.width,
        child: Stack(
          children: <Widget>[
            Positioned(
                left: sizeQuery.width * 0.8,
                child: GestureDetector(
                  onTap: () async {
                    _executeAction = await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height: sizeQuery.height * 0.18,
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              addAutomaticKeepAlives: false,
                              children: <Widget>[
                                ListTile(
                                  title: Text("Edit this Event"),
                                  onTap: () {
                                    Navigator.pop(context, 0);
                                  },
                                ),
                                ListTile(
                                  title: Text("Delete this Event"),
                                  onTap: () {
                                    Navigator.pop(context, 1);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                    if (_executeAction == 1) {
                      await DatabaseService(uid: _user.uid).deleteEvent(event);
                      actionable(null, 1);
                    } else {
                      actionable(event, 0);
                    }
                  },
                  child: Container(
                    child: FaIcon(
                      FontAwesomeIcons.ellipsisV,
                      color: Colors.white,
                    ),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    )),
                SizedBox(height: 10),
                Text(
                  "Starts:  ${event.eventFromDate.day} ${DateFormat("MMMM").format(event.eventFromDate)} ${DateFormat("y").format(event.eventFromDate)} ${DateFormat("jm").format(event.eventFromDate)}",
                ),
                Text(
                  "Ends:  ${event.eventToDate.day} ${DateFormat("MMMM").format(event.eventToDate)} ${DateFormat("y").format(event.eventToDate)} ${DateFormat("MMMM").format(event.eventToDate)} ${DateFormat("jm").format(event.eventToDate)}",
                ),
                SizedBox(height: 20.0),
                Text(event.description ?? "",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 15,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
