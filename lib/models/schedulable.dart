import 'package:flutter/material.dart';
import 'package:dayly/models/event.dart';

class Schedulable extends Comparable<Schedulable> {
  String name;
  String description;
  bool isDone;
  bool toBeScheduled;
  int priorityScore;
  int duration;
  String tag;
  DateTime dateTime;
  String category;
  DateTime endTime;
//  String documentId;

  Schedulable({
    @required this.name,
    this.isDone = false,
    this.toBeScheduled = false,
    this.description,
    this.priorityScore,
    this.duration,
    this.tag,
    this.dateTime,
    this.category,
    this.endTime,
//    this.documentId,
  });

  void toggleScheduling() {
    this.toBeScheduled = !this.toBeScheduled;
  }

  @override
  int compareTo(Schedulable task) {
    if (this.priorityScore > task.priorityScore) {
      return 0;
    } else if (this.priorityScore == task.priorityScore) {
      if (this.tag == 'Work') {
        return 0;
      } else if (task.tag == 'Work') {
        return 1;
      } else if (this.tag == 'Study') {
        return 0;
      } else if (task.tag == 'Study') {
        return 1;
      } else {
        return 0;
      }
    } else {
      return 1;
    }
  }

  String getDuration(int duration) {
    if (duration != null) {
      String hours = (duration / 60).toStringAsFixed(1);
      return hours + ' h';
    } else {
      return ' None ';
    }
  }

  int getTotalDuration(List<Schedulable> selectedTasks) {
    int result = 0;
    for (int i = 0; i < selectedTasks.length; i++) {
      result += selectedTasks[i].duration;
    }
    return result;
  }

  void changeDuration(double factor) {
    this.duration = (this.duration * factor).round();
  }

//  Schedulable eventToSchedulable(Event event) {
//    return Schedulable(
//        name: event.title,
//        description: event.description,
//        category: 'Event',
//        priorityScore: 1,
//        toBeScheduled: true,
//        dateTime: event.eventFromDate,
//        endTime: event.eventToDate);
//  }

//  void sort(List<Schedulable> listOfSchedulable) {
//    listOfSchedulable.sort((a, b) => a.compareTo(b));
//  }
}
