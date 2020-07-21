import 'package:googleapis/androidmanagement/v1.dart';
import 'package:googleapis/games/v1.dart';

class Score implements Comparable<Score> {
  final String uid;
  final String name;
  final int score;

  Score({this.uid, this.name, this.score});

  @override
  int compareTo(Score other) {
    return other.score - score;
  }
}
