import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  final String uid;

  User({ this.uid });
}

class UserData extends ChangeNotifier {
  final String uid;
  final String email;
  final String name;
  final String type;
  final String imageUrl;

  UserData({ this.uid, this.email, this.name, this.type, this.imageUrl});

}