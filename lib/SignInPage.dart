import 'package:flutter/material.dart';
import 'constants.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text(
          'dayly',
          style: kAppBarTitleTextStyle,
        ),
      ),
    );
  }
}
