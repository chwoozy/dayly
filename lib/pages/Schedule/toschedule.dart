import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'schedule_screen.dart';
import 'package:dayly/models/task_data.dart';
import 'package:dayly/models/user.dart';

class ToSchedule extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        theme: _themeData,
        home: ScheduleScreen(),
      ),
    );
  }
}
