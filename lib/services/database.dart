import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/sort_manager.dart';
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

//  final CollectionReference scheduleCollection =
////      Firestore.instance.collection('schedule');

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

  // Get List of Event
  Future<List<Event>> get allEvents async {
    final QuerySnapshot result =
        await userCollection.document(uid).collection('event').getDocuments();
    final mapped = result.documents.map(_eventFromSnapshot);
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
      eid: snapshot.data['eid'].toString(),
      title: snapshot.data['title'],
      description: snapshot.data['description'],
      eventFromDate: snapshot.data['eventFromDate'].toDate(),
      eventToDate: snapshot.data['eventToDate'].toDate(),
      eventColor: Color(snapshot.data['eventColor']).withOpacity(1),
      recurrenceRule: snapshot.data['recurrenceRule'],
    );
  }

  Stream<QuerySnapshot> getUserTaskStreamSnapShots(
      BuildContext context) async* {
    yield* taskCollection.document(uid).collection('tasks').snapshots();
  }

  Stream<QuerySnapshot> getUserScheduleStreamSnapShots(
      BuildContext context) async* {
    yield* taskCollection.document(uid).collection('schedule').snapshots();
  }

  getSchedule(TaskData taskData) async {
    QuerySnapshot snapshot = await taskCollection
        .document(uid)
        .collection('schedule')
        .getDocuments();
    List<Schedulable> _scheduleList = [];
    snapshot.documents.forEach((document) {
      String name = document.data['name'];
      String description = document.data['description'];
      bool isDone = document.data['isDone'];
      bool toBeScheduled = document.data['toBeScheduled'];
      int priorityScore = document.data['priorityScore'];
      int duration = document.data['duration'];
      String tag = document.data['tag'];
      DateTime dateTime = document.data['dateTime'].toDate();
      String category = document.data['category'];
      DateTime endTime = document.data['endTime'].toDate();
      Schedulable schedule = Schedulable(
          name: name,
          description: description,
          isDone: isDone,
          toBeScheduled: toBeScheduled,
          priorityScore: priorityScore,
          duration: duration,
          tag: tag,
          dateTime: dateTime,
          category: category,
          endTime: endTime);
      _scheduleList.add(schedule);
    });
    SortManager().sort(_scheduleList);
    taskData.scheduleList = _scheduleList;
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

  Future deleteSchedule() async {
    QuerySnapshot snapshot = await taskCollection
        .document(uid)
        .collection('schedule')
        .getDocuments();
    snapshot.documents.forEach((document) {
      document.reference.delete();
    });
  }
}
