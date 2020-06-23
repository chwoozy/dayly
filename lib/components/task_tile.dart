import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final String taskDescription;
  final Function checkboxCallback;
  final Color categoryColor;

  TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.taskDescription,
      this.categoryColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        height: 136,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: categoryColor,
        ),
        child: ListTile(
          title: Text(
            taskTitle,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
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
