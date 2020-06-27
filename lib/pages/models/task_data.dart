import 'package:flutter/foundation.dart';
import 'package:dayly/pages/models/task.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskData extends ChangeNotifier {
  int _finishedTaskCount = 0;

  List<Task> _tasks = [];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  int get finishedTaskCount {
    return _finishedTaskCount;
  }

  set finishedTaskNum(int finishedTask) {
    _finishedTaskCount = finishedTask;
  }

  //Add new task to list
  void addTask(String taskTitle, String taskDescription, Color tagColor) {
    final task =
        Task(name: taskTitle, description: taskDescription, color: tagColor);
    _tasks.add(task);
    notifyListeners();
  }

  //Update the status of task
  void updateTask(Task task) {
    if (!task.isDone) {
      _finishedTaskCount += 1;
    } else {
      _finishedTaskCount -= 1;
    }
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) async {
    if (task.isDone) {
      _finishedTaskCount -= 1;
    }
    _tasks.remove(task);
    notifyListeners();
  }

  set taskList(List<Task> taskList) {
    _tasks = taskList;
    notifyListeners();
  }
}
