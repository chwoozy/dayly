import 'package:dayly/models/schedulable.dart';
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

  DateTime intToTime(int time) {
    DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      time ~/ 60,
      time % 60,
    );
  }

  List<Schedulable> schedule() {
    List<Schedulable> finalResult = [];

    List<Itl.Interval> initial = [
      Itl.Interval(timeToInt(startingTime), timeToInt(endTime), false)
    ];
    List<Itl.Interval> events = [];

    for (Schedulable i in listForScheduling) {
      if (i.category == 'Event') {
        events.add(
            Itl.Interval(timeToInt(i.dateTime), timeToInt(i.endTime), false));
      }
    }

    List<AnnotatedPoint> queue = this.initQueue(initial, events);
    List<Itl.Interval> result = this.doSweep(queue);

    for (Schedulable i in listForScheduling) {
      if (i.category == 'Task' && i.toBeScheduled) {
        for (Itl.Interval j in result) {
          if (j.occupied) {
            continue;
          } else {
            if ((j.end - j.start) > i.duration) {
              i.dateTime = intToTime(j.start);
              i.endTime = intToTime(j.start + i.duration);
              j.start = j.start + i.duration;
              finalResult.add(Schedulable(
                  name: i.name,
                  description: i.description,
                  priorityScore: i.priorityScore,
                  duration: i.duration,
                  toBeScheduled: false,
                  dateTime: i.dateTime,
                  endTime: i.endTime,
                  category: i.category));
              break;
            } else if ((j.end - j.start) == i.duration) {
              j.occupied = true;
              i.dateTime = intToTime(j.start);
              i.endTime = intToTime(j.end);
              finalResult.add(Schedulable(
                  name: i.name,
                  description: i.description,
                  priorityScore: i.priorityScore,
                  duration: i.duration,
                  toBeScheduled: false,
                  dateTime: i.dateTime,
                  endTime: i.endTime,
                  category: i.category));
              break;
            } else {
              i.dateTime = intToTime(j.start);
              i.endTime = intToTime(j.end);
              j.occupied = true;
              Schedulable newSchedule = Schedulable(
                  name: i.name,
                  description: i.description,
                  priorityScore: i.priorityScore,
                  duration: j.end - j.start,
                  category: i.category,
                  toBeScheduled: false,
                  dateTime: i.dateTime = intToTime(j.start),
                  endTime: i.endTime = intToTime(j.end));
              finalResult.add(newSchedule);
              i.duration -= j.end - j.start;
            }
          }
        }
      } else {
        if (i.dateTime.compareTo(startingTime) == 1) {
          finalResult.add(i);
        }
      }
    }
    finalResult.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return finalResult;
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
            result.add(Itl.Interval(intervalStart, point.value, false));
          }
          isInterval = false;
          break;
        case PointType.GapStart:
          if (isInterval) {
            result.add(Itl.Interval(intervalStart, point.value, false));
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

//void main() {
//  DateTime startingTime = DateTime(2020, 1, 1, 15, 25);
//  DateTime endTime = DateTime(2020, 1, 1, 21, 0);
//  List<Schedulable> testingList = [
//    Schedulable(
//        name: 'Event1',
//        dateTime: DateTime(2020, 1, 1, 15, 42),
//        endTime: DateTime(2020, 1, 1, 16, 01),
//        category: 'Event'),
//    Schedulable(
//        name: 'Task1', duration: 120, category: 'Task', toBeScheduled: true),
//    Schedulable(
//        name: 'Task2', duration: 60, category: 'Task', toBeScheduled: true),
//    Schedulable(
//        name: 'Task3', duration: 30, category: 'Task', toBeScheduled: true),
//  ];
//  ScheduleManager manager = ScheduleManager(
//      startingTime: startingTime,
//      endTime: endTime,
//      listForScheduling: testingList);
//  List<Schedulable> resultList = manager.schedule();
////  for (Schedulable item in resultList) {
////    print(item.dateTime.toString() + item.name);
////  }
//}
