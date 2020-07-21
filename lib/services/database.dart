import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/score.dart';
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

  final CollectionReference scoreCollection =
      Firestore.instance.collection('score');

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
      'eid': event.eid,
      'title': event.title,
      'description': event.description,
      'eventFromDate': event.eventFromDate,
      'eventToDate': event.eventToDate,
      'eventColor': event.eventColor.value,
      'recurrenceRule': event.recurrenceRule,
    });
  }

  Future updateScore(Score score) async {
    return await scoreCollection.document(uid).setData({
      'uid': score.uid,
      'name': score.name,
      'score': score.score,
    });
  }

  Future addScore(Score score, int gems) async {
    return await scoreCollection.document(uid).setData({
      'uid': score.uid,
      'name': score.name,
      'score': score.score + gems,
    });
  }

  Future<void> deleteEvent(Event event) async {
    return await userCollection
        .document(uid)
        .collection('event')
        .document(event.eid)
        .delete();
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

  // Get Single User Data
  Future<UserData> get fetchUserData async {
    DocumentSnapshot result = await userCollection
        .document(uid)
        .collection("profile")
        .document("userinfo")
        .get();
    return _userDataFromSnapshot(result);
  }

  // Get List of Event
  Future<List<Event>> get allEvents async {
    final QuerySnapshot result =
        await userCollection.document(uid).collection('event').getDocuments();
    final mapped = result.documents.map(_eventFromSnapshot);
    return mapped.toList();
  }

  // Get Score
  Future<List<Score>> get getScore async {
    final QuerySnapshot result = await scoreCollection.getDocuments();
    final mapped = result.documents.map(_scoreFromSnapshot);
    return mapped.toList();
  }

  // Get Single Score Data
  Future<Score> get getPersonalScore async {
    DocumentSnapshot result = await scoreCollection.document(uid).get();
    return _scoreFromSnapshot(result);
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
      eid: snapshot.data['eid'].toString(),
      title: snapshot.data['title'],
      description: snapshot.data['description'],
      eventFromDate: snapshot.data['eventFromDate'].toDate(),
      eventToDate: snapshot.data['eventToDate'].toDate(),
      eventColor: Color(snapshot.data['eventColor']).withOpacity(1),
      recurrenceRule: snapshot.data['recurrenceRule'],
    );
  }

  // Score from Snapshot
  Score _scoreFromSnapshot(DocumentSnapshot snapshot) {
    return Score(
      uid: snapshot.data['uid'],
      name: snapshot.data['name'],
      score: snapshot.data['score'],
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
      int priorityScore = document.data['priorityScore'];
      int duration = document.data['duration'];
      String documentId = document.reference.documentID;
      Task task = Task(
        name: taskTitle,
        description: taskSummary,
        isDone: isDone,
        documentId: documentId,
        tag: tag,
        priorityScore: priorityScore,
        duration: duration,
      );
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
    return await doc.setData({
      'taskName': task.name,
      'taskDescription': task.description,
      'isDone': isDone,
      'documentId': task.documentId,
      'tag': task.tag,
      'priorityScore': task.priorityScore,
      'duration': task.duration,
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
