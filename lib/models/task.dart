import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String name;
  String description;
  bool isDone;
  String tag;
  String documentId;
  int priorityScore;

  Task(
      {@required this.name,
      this.isDone = false,
      this.description,
      this.tag,
      this.documentId,
      this.priorityScore});

  void toggleDone() {
    isDone = !isDone;
  }

  //Convert to Json format
  Map<String, dynamic> toMap() {
    return {
      'taskName': name,
      'taskDescription': description,
      'isDone': isDone,
      'documentId': documentId,
      'tag': tag,
      'priorityScore': priorityScore,
    };
  }

  //Read snapshot from Firebase
  Task.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot['taskName'];
    description = snapshot['taskDescription'];
    documentId = snapshot.documentID;
    tag = snapshot['tag'];
    priorityScore = snapshot['priorityScore'];
  }
}
