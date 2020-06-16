import 'package:dayly/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:dayly/pages/todo/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:dayly/pages/todo/widgets/tasks_list.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dayly/pages/todo/screens/add_task_screen.dart';

class ToDo extends StatelessWidget {
//class ToDo extends StatefulWidget {
//  @override
//  _ToDoState createState() => _ToDoState();
//}
//
//class _ToDoState extends State<ToDo> {
////  @override
////  void initState() {
////    super.initState();
////    final _user = Provider.of<User>(context);
////    DatabaseService databaseService = DatabaseService(uid: _user.uid);
////    TaskData taskData = Provider.of<TaskData>(context);
////    databaseService.getTaskData(taskData);
////  }

  @override
  Widget build(BuildContext context) {
//    final _user = Provider.of<User>(context);
//    print(_user.uid);
//    DatabaseService databaseService = DatabaseService(uid: _user.uid);
//    TaskData taskData = Provider.of<TaskData>(context);
//    databaseService.getTaskData(taskData);
//    print(taskData.taskCount);

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddTaskScreen(),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                    color: Colors.lightBlueAccent,
                  ),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Dayly Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${Provider.of<TaskData>(context).taskCount} Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: TasksList(),
            ),
          )
        ],
      ),
    );
  }
}
