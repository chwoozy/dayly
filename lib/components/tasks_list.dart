import 'package:flutter/material.dart';
import 'package:dayly/components/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:dayly/pages/models/task_data.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 5),
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  taskData.deleteTask(task);
                });
              },
              child: TaskTile(
                taskTitle: task.name,
                taskDescription: task.description,
                isChecked: task.isDone,
                checkboxCallback: (checkboxState) {
                  taskData.updateTask(task);
                },
                categoryColor: task.color,
              ),
              background: Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.blueGrey),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
