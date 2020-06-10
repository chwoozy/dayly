import 'package:dayly/pages/authenticate/landing.dart';
import 'package:dayly/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayly/pages/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

     final user = Provider.of<User>(context);
     print("Logged in with:" + user.toString());

    if (user == null) {
      return Landing();
    } else {
      return Home(user: user);
    }
  }
}