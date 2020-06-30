import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final String taskDescription;
  final Function checkboxCallback;
  final String category;

  TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.taskDescription,
      this.category});

  Color getTagColor(String tag) {
//    if (tag == null) {
//      return Colors.white;
//    } else {
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
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        height: 136,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: getTagColor(this.category),
        ),
        child: ListTile(
          title: Text(
            taskTitle,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  decoration: isChecked ? TextDecoration.lineThrough : null),
            ),
          ),
          subtitle: taskDescription == null
              ? null
              : Text(
                  taskDescription,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
          trailing: Checkbox(
            value: isChecked,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            activeColor: Colors.purple,
            onChanged: checkboxCallback,
          ),
        ),
      ),
    );
  }
}
