import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String name;
  String description;
  bool isDone;
  String tag;
  String documentId;
  int priorityScore;
  int duration;

  Task({
    @required this.name,
    this.isDone = false,
    this.description,
    this.tag,
    this.documentId,
    this.priorityScore,
    this.duration,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  Schedulable toSchedulable() {
    return Schedulable(
      name: this.name,
      description: this.description,
      isDone: this.isDone,
      priorityScore: this.priorityScore,
      duration: this.duration,
      category: 'Task',
      tag: this.tag,
    );
  }

  //Convert to Json format
//  Map<String, dynamic> toMap() {
//    return {
//      'taskName': name,
//      'taskDescription': description,
//      'isDone': isDone,
//      'documentId': documentId,
//      'tag': tag,
//      'priorityScore': priorityScore,
//      'duration': duration,
//    };
//  }

  //Read snapshot from Firebase
//  Task.fromSnapshot(DocumentSnapshot snapshot) {
//    name = snapshot['taskName'];
//    description = snapshot['taskDescription'];
//    documentId = snapshot.documentID;
//    tag = snapshot['tag'];
//    priorityScore = snapshot['priorityScore'];
//    duration = snapshot['duration']
//  }
}
