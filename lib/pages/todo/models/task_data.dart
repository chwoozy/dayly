import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dayly/pages/todo/models/Task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk'),
  ];

  set setTasks(List<Task> taskList) {
    _tasks = taskList;
    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    notifyListeners();
    //print(_tasks.length);
    for (int i = 0; i < _tasks.length; i++) {
      print(_tasks[i].name);
    }
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
