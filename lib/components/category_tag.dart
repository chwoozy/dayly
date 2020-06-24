import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTag extends StatelessWidget {
  final String categoryTag;
  final Color tagColor;
  final Function onPressCallback;

  CategoryTag(
      {@required this.categoryTag,
      @required this.tagColor,
      @required this.onPressCallback});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressCallback,
      disabledColor: tagColor,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Text(
        categoryTag,
        style: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      color: tagColor,
      textColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
