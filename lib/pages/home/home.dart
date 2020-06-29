import 'package:dayly/components/constants.dart';
import 'package:dayly/pages/calendar/calendar.dart';
import 'package:dayly/pages/profile/profile.dart';
import 'package:dayly/pages/todo_list/todo.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Calendar(),
    ToDo(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryBackgroundColor,
        body: _children[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          index: _currentIndex,
          backgroundColor: primaryBackgroundColor,
          color: secondaryBackgroundColor,
          items: <Widget>[
            Icon(Icons.event, size: 30, color: primaryPurple),
            Icon(Icons.assignment, size: 30, color: primaryPurple),
            Icon(Icons.perm_identity, size: 30, color: primaryPurple),
          ],
          animationDuration: Duration(
            milliseconds: 200,
          ),
          onTap: (index) {
            //Handle button tap
            setState(() => _currentIndex = index);
          },
        ));
  }
}
