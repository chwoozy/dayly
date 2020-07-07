import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final String taskDescription;
  final Function checkboxCallback;
  final String category;
  final int priority;
  final int duration;

  TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.taskDescription,
      this.category,
      this.priority,
      this.duration});

  Color getTagColor(String tag) {
    if (tag == null) {
      return Colors.white;
    } else {
      if (tag == 'Work') {
        return Colors.red.shade300;
      } else if (tag == 'Study') {
        return Colors.yellow;
      } else if (tag == 'Event') {
        return Colors.orangeAccent;
      } else if (tag == 'LifeStyle') {
        return Colors.blueAccent.shade100;
      } else if (tag == 'Miscellaneous') {
        return Colors.greenAccent;
      } else {
        return Colors.white;
      }
    }
  }

  IconData getTagIcon(String tag) {
    if (tag == null) {
      return Icons.add_alert;
    } else {
      if (tag == 'Work') {
        return Icons.work;
      } else if (tag == 'Study') {
        return Icons.book;
      } else if (tag == 'Event') {
        return Icons.event;
      } else if (tag == 'LifeStyle') {
        return Icons.fitness_center;
      } else if (tag == 'Miscellaneous') {
        return Icons.local_grocery_store;
      } else {
        return Icons.add_alert;
      }
    }
  }

  String getPriority(int priorityScore) {
    if (priorityScore < 33) {
      return 'Low';
    } else if (priorityScore < 66) {
      return 'Normal';
    } else if (priorityScore < 99) {
      return 'Important';
    } else {
      return 'Critical';
    }
  }

  String getDuration(int duration) {
    if (duration != null) {
//      int hours = duration ~/ 60;
//      int mins = duration - hours * 60;
//      return hours.toString() + 'h ' + mins.toString() + 'm';
      String hours = (duration / 60).toStringAsFixed(1);
      return hours + ' h';
    } else {
      return ' None ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: getTagColor(this.category),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Icon(
                      getTagIcon(this.category),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          taskTitle,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                        ),
                        Text(
                          taskDescription == null ? '' : taskDescription,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_alarm,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                'Duration: ' + getDuration(this.duration),
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.assignment_late,
                              color: Colors.black,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                'Priority: ${getPriority(this.priority)}',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Checkbox(
                      value: isChecked,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      activeColor: Colors.purple,
                      onChanged: checkboxCallback,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
//    return Padding(
//      padding: EdgeInsets.symmetric(vertical: 5),
//      child: Container(
//        padding: EdgeInsets.all(15),
//        height: 136,
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(25),
//          color: getTagColor(this.category),
//        ),
//        child: ListTile(
//          title: Text(
//            taskTitle,
//            style: GoogleFonts.lato(
//              textStyle: TextStyle(
//                  color: Colors.white,
//                  fontSize: 20,
//                  fontWeight: FontWeight.w600,
//                  decoration: isChecked ? TextDecoration.lineThrough : null),
//            ),
//          ),
//          subtitle: taskDescription == null
//              ? null
//              : Text(
//                  taskDescription,
//                  style: GoogleFonts.lato(
//                    textStyle: TextStyle(
//                      color: Colors.white,
//                      fontSize: 13,
//                      fontWeight: FontWeight.w700,
//                    ),
//                  ),
//                ),
//          trailing: Checkbox(
//            value: isChecked,
//            materialTapTargetSize: MaterialTapTargetSize.padded,
//            activeColor: Colors.purple,
//            onChanged: checkboxCallback,
//          ),
//        ),
//      ),
//    );
  }
}
