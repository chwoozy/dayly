import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color iconColor;
  final double textSize;
  final double height;
  final Color color;
  final Function onPressed;

  MenuButton(
      {this.text,
      this.iconData,
      this.iconColor,
      this.textSize,
      this.height,
      this.color,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            iconData,
            color: iconColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: color, fontSize: textSize),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
