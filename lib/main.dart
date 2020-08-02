import 'package:dayly/pages/authenticate/landing.dart';
import 'package:dayly/pages/authenticate/login.dart';
import 'package:dayly/pages/authenticate/signup.dart';
import 'package:dayly/pages/calendar/add_event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/wrapper.dart';
import 'package:dayly/services/auth.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgwOzw8PSQ2OiQTND4yOj99MDw+');
  // runApp(DevicePreview(builder: (context) => Dayly()));
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
  accentColor: Colors.indigoAccent[700],
);

class Dayly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        Provider<AuthService>.value(value: AuthService()),
      ],
      child: MaterialApp(
          // builder: DevicePreview.appBuilder,
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
