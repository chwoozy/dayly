import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String name;
  String description;
  bool isDone;
  dynamic color;
  //final String tag;
  String documentId;

  Task(
      {@required this.name,
      this.isDone = false,
      this.description,
      this.color = Colors.blueAccent,
      //this.tag,
      this.documentId});

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toMap() {
    return {
      'taskName': name,
      'taskDescription': description,
      'isDone': isDone,
      'documentId': documentId,
    };
  }

  Task.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot['taskName'];
    description = snapshot['taskDescription'];
    documentId = snapshot.documentID;
  }
}
