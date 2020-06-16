import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:dayly/pages/todo/models/Task.dart';
import 'package:dayly/pages/todo/models/task_data.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  final CollectionReference taskDataCollection =
      Firestore.instance.collection('task_data');

  Future updateUserData(
      String name, String email, String type, String imageUrl) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'email': email,
      'type': type,
      'imageUrl': imageUrl,
    });
  }

  // Get User Data Stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  // User Data from Snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      type: snapshot.data['type'],
      imageUrl: snapshot.data['imageUrl'],
    );
  }

  Future updateUserTaskData(List<Task> taskList) async {
    return await taskDataCollection.document(uid).setData({
      'taskData': taskList,
    });
  }

  getTaskData(TaskData taskData) async {
    DocumentSnapshot snapshot = await taskDataCollection.document(uid).get();
    List<Task> taskList = snapshot.data['taskData'];
    print(taskList.length);
    taskData.setTasks = taskList;
  }
}
