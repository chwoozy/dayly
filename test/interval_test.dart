class Interval {
  int start, end;

  Interval(int start, int end) {
    this.start = start;
    this.end = end;
  }

  String toString() {
    return "(" + start.toString() + "," + end.toString() + ")";
  }
}

// the order is important here: if multiple events happen at the same point,
// this is the order in which you want to deal with them
enum PointType { End, GapEnd, GapStart, Start }

class AnnotatedPoint extends Comparable<AnnotatedPoint> {
  int value;
  PointType type;

  AnnotatedPoint(int value, PointType type) {
    this.value = value;
    this.type = type;
  }

  @override
  int compareTo(AnnotatedPoint other) {
    if (other.value == this.value) {
      return this.type.index < other.type.index ? -1 : 1;
    } else {
      return this.value < other.value ? -1 : 1;
    }
  }
}

class Test {
//  void main() {
//    List<Interval> interval = [Interval(0, 10), Interval(15, 20)];
//    List<Interval> remove = [Interval(2, 3), Interval(5, 6)];
//
//    List<AnnotatedPoint> queue = initQueue(interval, remove);
//    List<Interval> result = doSweep(queue);
//
//    // print result
//    for (Interval i in result) {
//      print(i);
//      }
//    }

  List<AnnotatedPoint> initQueue(
      List<Interval> interval, List<Interval> remove) {
    // annotate all points and put them in a list
    List<AnnotatedPoint> queue = new List();
    for (Interval i in interval) {
      queue.add(AnnotatedPoint(i.start, PointType.Start));
      queue.add(AnnotatedPoint(i.end, PointType.End));
    }
    for (Interval i in remove) {
      queue.add(AnnotatedPoint(i.start, PointType.GapStart));
      queue.add(AnnotatedPoint(i.end, PointType.GapEnd));
    }

    // sort the queue
    //Collections.sort(queue);
    queue.sort();
    return queue;
  }

  List<Interval> doSweep(List<AnnotatedPoint> queue) {
    List<Interval> result = List();

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
            result.add(new Interval(intervalStart, point.value));
          }
          isInterval = false;
          break;
        case PointType.GapStart:
          if (isInterval) {
            result.add(new Interval(intervalStart, point.value));
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
  Test tester = Test();
  List<Interval> interval = [Interval(5, 1000)];
  List<Interval> remove = [Interval(2, 3), Interval(5, 6)];

  List<AnnotatedPoint> queue = tester.initQueue(interval, remove);
  List<Interval> result = tester.doSweep(queue);

  // print result
  for (Interval i in result) {
    print(i);
  }
}
