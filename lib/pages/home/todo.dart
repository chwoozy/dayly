import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: Text('ToDo'),
        backgroundColor: primaryPurple,
        elevation: 0.0,
      ),
    );
  }
}