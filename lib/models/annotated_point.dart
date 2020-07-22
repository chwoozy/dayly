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
