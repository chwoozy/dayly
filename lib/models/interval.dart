class Interval {
  int start, end;
  bool occupied = false;

  Interval(int start, int end, bool occupied) {
    this.start = start;
    this.end = end;
    this.occupied = false;
  }

  String toString() {
    return "(" + start.toString() + "," + end.toString() + ")";
  }
}
