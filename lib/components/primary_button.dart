import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final Function onTap;

  PrimaryButton({this.title, this.onTap});
  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    Size sizeQuery = MediaQuery.of(context).size;
    double textSizeQuery = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.indigoAccent[700],
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: sizeQuery.width * 0.08),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: textSizeQuery * 25),
            ),
          )),
    );
  }
}
