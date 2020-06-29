import 'package:dayly/pages/authenticate/landing.dart';
import 'package:dayly/pages/calendar/add_event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/wrapper.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Dayly());
}

class Dayly extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(initialRoute: '/wrapper', routes: {
        '/landing': (context) => Landing(),
        '/wrapper': (context) => Wrapper(),
        '/addevent': (context) => AddEvent(),
      }),
    );
  }
}
