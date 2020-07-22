import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final String tag;
  final Function onPressCallback;

  FloatingButton(
      {@required this.icon,
      @required this.tag,
      @required this.onPressCallback});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: tag,
      backgroundColor: Colors.red,
      elevation: 10,
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
      onPressed: onPressCallback,
    );
  }
}
