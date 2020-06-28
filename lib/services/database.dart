import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/customsearch/v1.dart';
import 'package:dayly/pages/models/task_data.dart';
import 'package:dayly/pages/models/task.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  final CollectionReference taskCollection =
      Firestore.instance.collection('task_data');

  Future updateUserData(
      String email, String displayName, String photoUrl) async {
    return await userCollection.document(uid).setData({
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    });
  }

  Future<DocumentSnapshot> get checkUser {
    return userCollection.document(uid).get();
  }

  // Get User Data Stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  // User Data from Snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      displayName: snapshot.data['displayName'],
      email: snapshot.data['email'],
      photoUrl: snapshot.data['photoUrl'],
    );
  }

  Stream<QuerySnapshot> getUserTaskStreamSnapShots(
      BuildContext context) async* {
    yield* taskCollection.document(uid).collection('tasks').snapshots();
  }

  getTasks(TaskData taskData) async {
    QuerySnapshot snapshot =
        await taskCollection.document(uid).collection('tasks').getDocuments();

    List<Task> _taskList = [];
    int _finishedTaskCount = 0;

    snapshot.documents.forEach((document) {
      String taskTitle = document.data['taskName'];
      String taskSummary = document.data['taskDescription'];
      bool isDone = document.data['isDone'];
      String documentId = document.reference.documentID;
      print(documentId);
      Task task = Task(
          name: taskTitle,
          description: taskSummary,
          isDone: isDone,
          documentId: documentId);
      _taskList.add(task);
      if (task.isDone) {
        _finishedTaskCount += 1;
      }
    });

    taskData.taskList = _taskList;
    taskData.finishedTaskNum = _finishedTaskCount;
  }

  Future updateTask(Task task, bool isDone) async {
    final doc = taskCollection
        .document(uid)
        .collection('tasks')
        .document(task.documentId);
    print(task.documentId);
    return await doc.setData({
      'taskName': task.name,
      'taskDescription': task.description,
      'isDone': isDone,
      'documentId': task.documentId,
    });
  }

  Future deleteTask(Task task) async {
    final doc = taskCollection
        .document(uid)
        .collection('tasks')
        .document(task.documentId);
    return await doc.delete();
  }
}
