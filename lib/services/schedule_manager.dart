import 'package:dayly/models/schedulable.dart';
import 'package:flutter/material.dart';
import 'package:dayly/models/annotated_point.dart';
import 'package:dayly/models/interval.dart' as Itl;

class ScheduleManager {
  DateTime startingTime;
  DateTime endTime;
  List<Schedulable> listForScheduling;

  ScheduleManager({this.startingTime, this.endTime, this.listForScheduling});

  int timeToInt(DateTime dateTime) {
    return dateTime.hour * 60 + dateTime.minute;
  }

  List<AnnotatedPoint> initQueue(
      List<Itl.Interval> interval, List<Itl.Interval> remove) {
    // annotate all points and put them in a list
    List<AnnotatedPoint> queue = new List();
    for (Itl.Interval i in interval) {
      queue.add(AnnotatedPoint(i.start, PointType.Start));
      queue.add(AnnotatedPoint(i.end, PointType.End));
    }
    for (Itl.Interval i in remove) {
      queue.add(AnnotatedPoint(i.start, PointType.GapStart));
      queue.add(AnnotatedPoint(i.end, PointType.GapEnd));
    }

    // sort the queue
    queue.sort();
    return queue;
  }

  List<Itl.Interval> doSweep(List<AnnotatedPoint> queue) {
    List<Itl.Interval> result = List();

    // iterate over the queue
    bool isInterval = false; // isInterval: #Start seen > #End seen
    bool isGap = false; // isGap:      #GapStart seen > #GapEnd seen
    int intervalStart = 0;
    for (AnnotatedPoint point in queue) {
      switch (point.type) {
        case PointType.Start:
          if (!isGap) {
            intervalStart = point.value;
          }
          isInterval = true;
          break;
        case PointType.End:
          if (!isGap) {
            result.add(Itl.Interval(intervalStart, point.value));
          }
          isInterval = false;
          break;
        case PointType.GapStart:
          if (isInterval) {
            result.add(Itl.Interval(intervalStart, point.value));
          }
          isGap = true;
          break;
        case PointType.GapEnd:
          if (isInterval) {
            intervalStart = point.value;
          }
          isGap = false;
          break;
      }
    }

    return result;
  }
}

void main() {
  ScheduleManager manager = ScheduleManager();
  List<Itl.Interval> interval = [Itl.Interval(0, 10), Itl.Interval(15, 20)];
  List<Itl.Interval> remove = [Itl.Interval(2, 3), Itl.Interval(5, 6)];

  List<AnnotatedPoint> queue = manager.initQueue(interval, remove);
  List<Itl.Interval> result = manager.doSweep(queue);

  // print result
  for (Itl.Interval i in result) {
    print(i);
  }
}
