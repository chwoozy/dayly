import 'package:dayly/components/constants.dart';
import 'package:dayly/pages/calendar/calendar.dart';
import 'package:dayly/pages/leaderboard/leaderboard.dart';
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
    Leaderboard(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _children[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          index: _currentIndex,
          backgroundColor: Theme.of(context).canvasColor,
          color: Theme.of(context).canvasColor,
          items: <Widget>[
            Icon(Icons.event, size: 30, color: Colors.tealAccent[400]),
            Icon(Icons.assignment, size: 30, color: Colors.tealAccent[400]),
            Icon(Icons.equalizer, size: 30, color: Colors.tealAccent[400]),
            Icon(Icons.perm_identity, size: 30, color: Colors.tealAccent[400]),
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
