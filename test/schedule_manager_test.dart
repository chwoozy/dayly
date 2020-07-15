import 'package:dayly/models/schedulable.dart';
import 'package:flutter/material.dart';

class ScheduleManager {
  DateTime startingTime;
  DateTime endTime;
  List<Schedulable> listForScheduling;

  ScheduleManager({this.startingTime, this.endTime, this.listForScheduling});

  int timeToInt(DateTime dateTime) {
    return dateTime.hour * 60 + dateTime.minute;
  }

  List<int> findTotalTime() {
    int totalTime = timeToInt(this.startingTime) - timeToInt(this.endTime);
    List<int> resultArray =
  }
}

ScheduleManager manager = ScheduleManager();

void main() {
  print(manager.timeToInt(DateTime.now()));
}


