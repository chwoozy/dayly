import 'package:dayly/models/schedulable.dart';

class SortManager {
  final base = 1;
  final double highProductivity = 0.8;
  final double mediumProductivity = 1.0;
  final double lowProductivity = 1.2;
  final double leftOver = 1.5;

  void sort(List<Schedulable> listOfSchedulable) {
    listOfSchedulable.sort((a, b) => a.compareTo(b));
  }
}
