import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tasks_screen.dart';
import 'package:dayly/pages/models/task_data.dart';
import 'package:dayly/pages/models/user.dart';

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}
