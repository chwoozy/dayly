import 'package:flutter/foundation.dart';
import 'package:dayly/pages/models/task.dart';
import 'dart:collection';
import 'package:flutter/material.dart';

class TaskData extends ChangeNotifier {
  int finishedTaskCount = 0;

  List<Task> _tasks = [];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String taskTitle, String taskDescription, Color tagColor) {
    final task =
        Task(name: taskTitle, description: taskDescription, color: tagColor);
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    if (!task.isDone) {
      finishedTaskCount += 1;
    } else {
      finishedTaskCount -= 1;
    }
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
