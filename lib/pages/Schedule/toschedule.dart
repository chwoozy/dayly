import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'schedule_screen.dart';
import 'package:dayly/models/task_data.dart';
import 'package:dayly/models/user.dart';

class ToSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        home: ScheduleScreen(),
      ),
    );
  }
}
