import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  final String name;
  final String description;
  bool isDone;
  final Color color;

  Task(
      {@required this.name, this.isDone = false, this.description, this.color});

  void toggleDone() {
    isDone = !isDone;
  }
}
