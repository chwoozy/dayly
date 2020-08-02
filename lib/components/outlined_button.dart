import 'package:flutter/material.dart';

class OutlinedButton extends StatefulWidget {
  final String title;
  final Function onTap;

  OutlinedButton({this.title, this.onTap});
  @override
  _OutlinedButtonState createState() => _OutlinedButtonState();
}

class _OutlinedButtonState extends State<OutlinedButton> {
  @override
  Widget build(BuildContext context) {
    Size sizeQuery = MediaQuery.of(context).size;
    double textSizeQuery = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: widget.onTap,
          child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              )),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: sizeQuery.width * 0.08),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: textSizeQuery * 25,
              ),
            ),
          )),
    );
  }
}
