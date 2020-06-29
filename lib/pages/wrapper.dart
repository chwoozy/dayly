import 'package:dayly/pages/authenticate/landing.dart';
import 'package:dayly/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);

    return FutureBuilder<User>(
        future: Future.value(_user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Successfully logged in!");
            return Home();
          } else {
            print("Trying to login...");
            return Landing();
          }
        });
  }
}
