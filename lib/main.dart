import 'package:dayly/pages/authenticate/landing.dart';
import 'package:dayly/pages/calendar/add_event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/wrapper.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31ifWN9ZmpoYmF8YGJ8ampqanNiYmlmamlmanMDHmgwOzw8PSQ2OiQTND4yOj99MDw+');
  runApp(Dayly());
}

final ThemeData _themeData = ThemeData(
  brightness: Brightness.dark,
  buttonColor: Colors.tealAccent[400],
  // appBarTheme: AppBarTheme(
  //   color: Color(0xFF303030),
  // ),
  fontFamily: 'Falling',
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.tealAccent[400],
  ),
  accentColor: Colors.red[400],
);

class Dayly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          initialRoute: '/wrapper',
          routes: {
            '/landing': (context) => Landing(),
            '/wrapper': (context) => Wrapper(),
            '/addevent': (context) => AddEvent(),
          },
          theme: _themeData),
    );
  }
}
