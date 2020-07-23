import 'package:dayly/responsive/base_widget.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(builder: (context, sizingInformation) {
      return Scaffold(
          body: Center(
        child: Text(sizingInformation.toString()),
      ));
    });
  }
}
