import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:dayly/models/task_data.dart';
import 'package:dayly/models/task.dart';

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
    return await userCollection
        .document(uid)
        .collection('profile')
        .document('userinfo')
        .setData({
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    });
  }

  Future updateEvent(Event event) async {
    return await userCollection
        .document(uid)
        .collection('event')
        .document(event.eid)
        .setData({
      'id': event.eid,
      'title': event.title,
      'description': event.description,
      'eventFromDate': event.eventFromDate,
      'eventToDate': event.eventToDate,
      'eventColor': event.eventColor.value,
    });
  }

  Future<DocumentSnapshot> get checkUser {
    return userCollection.document(uid).get();
  }

  // Get User Data Stream
  Stream<UserData> get userData {
    return userCollection
        .document(uid)
        .collection("profile")
        .document("userinfo")
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  // Get List of Event
  Future<List<Event>> get allEvents async {
    final QuerySnapshot result =
        await userCollection.document(uid).collection('event').getDocuments();
    final mapped = result.documents.map(_eventFromSnapshot);
    print(mapped.toList());
    return mapped.toList();
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

  // Event from Snapshot
  Event _eventFromSnapshot(DocumentSnapshot snapshot) {
    return Event(
      eid: snapshot.data['eid'],
      title: snapshot.data['title'],
      description: snapshot.data['description'],
      eventFromDate: snapshot.data['eventFromDate'].toDate(),
      eventToDate: snapshot.data['eventToDate'].toDate(),
      eventColor: Color(snapshot.data['eventColor']).withOpacity(1),
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
      String tag = document.data['tag'];
      String documentId = document.reference.documentID;
      print(documentId);
      Task task = Task(
          name: taskTitle,
          description: taskSummary,
          isDone: isDone,
          documentId: documentId,
          tag: tag);
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
      'tag': task.tag,
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
