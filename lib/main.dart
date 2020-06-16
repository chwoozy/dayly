import 'package:dayly/pages/authenticate/landing.dart';
import 'package:dayly/pages/authenticate/signup.dart';
import 'package:dayly/pages/authenticate/login.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:dayly/pages/todo/models/task_data.dart';
import 'package:dayly/pages/wrapper.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Dayly());
}

class Dayly extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: ChangeNotifierProvider(
        create: (context) => TaskData(),
        child: MaterialApp(initialRoute: '/wrapper', routes: {
          '/landing': (context) => Landing(),
          '/login': (context) => Login(),
          '/signup': (context) => SignUp(),
          '/wrapper': (context) => Wrapper(),
        }),
      ),
    );
  }
}
