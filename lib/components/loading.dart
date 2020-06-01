import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBackgroundColor,
      child: Center(
        child: SpinKitDoubleBounce(
          color: primaryPurple,
          size: 50.0,
        )
      ),
    );
  }
}