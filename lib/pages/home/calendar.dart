import 'package:dayly/components/constants.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
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
    );
  }
}
