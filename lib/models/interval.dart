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

