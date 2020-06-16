import 'package:flutter/material.dart';
import 'package:dayly/pages/todo/widgets/task_tile.dart';
import 'package:dayly/pages/todo/models/task_data.dart';
import 'package:provider/provider.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
//            for (int i = 0; i < taskData.taskCount; i++) {
//              print(taskData.tasks[i].name);
//            }
            //print(taskData.taskCount);
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              longPressCallback: () {
                taskData.deleteTask(task);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
