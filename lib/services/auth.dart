import 'dart:ui';
import 'package:dayly/models/score.dart';
import 'package:flutter/material.dart' as material;
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:dayly/services/googlehttpclient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dayly/models/event.dart' as eventModel;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    CalendarApi.CalendarScope,
  ]);

  // User Object from FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Auth Change Stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  Future<FirebaseUser> get authUser {
    return _auth.currentUser();
  }

  Future getEvents(String uid) async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final headers = await googleSignInAccount.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    var calendar = CalendarApi(httpClient);
    var calEvents = calendar.events.list("primary");
    calEvents.then((events) {
      events.items.forEach((value) async {
        // print(
        //     "iCalUID: ${value.iCalUID} eTag: ${value.etag} eTag: ${value.etag} id: ${value.id} kind: ${value.kind} status: ${value.status} reminders: ${value.reminders} colorID: ${value.colorId}");
        eventModel.Event newEvent = eventModel.Event(
          eid: value.iCalUID,
          title: value.summary,
          description: value.description,
          eventFromDate: value.start.dateTime ?? value.start.date,
          eventToDate: value.end.dateTime ?? value.end.date,
          eventColor: material.Colors.orange,
          recurrenceRule: value.recurrence == null
              ? null
              : value.recurrence.length == 2
                  ? value.recurrence[1].substring(6)
                  : value.recurrence[0].substring(6),
        );
        await DatabaseService(uid: uid).updateEvent(newEvent);
      });
      print("Complete import from Google Calendar!");
    });
  }

  // Sign In with Google
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      // Assertions
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      bool isNewUser = await DatabaseService(uid: user.uid).newUser;
      if (isNewUser) {
        DatabaseService databaseService = DatabaseService(uid: user.uid);
        await databaseService.updateUserData(
            user.email, user.displayName, user.photoUrl, "Google");
        await databaseService.updateScore(
            Score(uid: user.uid, name: user.displayName, score: 0));
        print("First time sign up with Google success!");
      }

      return 'Sign in with google succeeded: $user';
    } catch (e) {
      print(e.toString());
      return 'Unsuccessful';
    }
  }

  // Email Login
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Email Signup
  Future signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      // Create a new collection document for user with the uid
      DatabaseService databaseService = DatabaseService(uid: user.uid);
      await databaseService.updateUserData(
          email,
          name,
          "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png",
          "Email");
      await databaseService
          .updateScore(Score(uid: user.uid, name: name, score: 0));
      print("Finishing email sign up...");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // // Sign Out
  // Future signOut() async {
  //   try {
  //     return await _auth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Sign Out with Google
  Future signOutGoogle() async {
    try {
      await _auth.signOut();
      print('FirebaseAuth: Successfully logged out!');
      await _googleSignIn.signOut();
      print('Google: Successfully logged out!');
    } catch (e) {
      print(e.toString());
    }
  }
}
