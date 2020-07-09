import 'dart:ui';
import 'package:flutter/material.dart' as material;
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:dayly/services/googlehttpclient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dayly/models/event.dart' as eventModel;

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
        if (value.recurrence != null) {
          value.recurrence.length == 2
              ? print(value.recurrence[1].substring(6))
              : print(value.recurrence[0].substring(6));
        }
        eventModel.Event newEvent = eventModel.Event.newEvent(
          value.summary,
          value.description,
          value.start.dateTime ?? value.start.date,
          value.end.dateTime ?? value.end.date,
          material.Colors.orange,
          value.recurrence == null
              ? null
              : value.recurrence.length == 2
                  ? value.recurrence[1].substring(6)
                  : value.recurrence[0].substring(6),
        );
        await DatabaseService(uid: uid).updateEvent(newEvent);
        // print(value.colorId);
      });
      print("Complete import from Google Calendar!");
    });
  }

  // Sign In with Google
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Assertions
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    bool isNewUser = !(await DatabaseService(uid: user.uid).checkUser).exists;
    print(isNewUser.toString());
    if (isNewUser) {
      await DatabaseService(uid: user.uid)
          .updateUserData(user.email, user.displayName, user.photoUrl);
      print("First time sign up with Google success!");
    }

    return 'Sign in with google succeeded: $user';
  }

  // // Email Login
  // Future loginWithEmailAndPassword(String email, String password) async {
  //   try {
  //     AuthResult result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // Email Signup
  // Future signUpWithEmailAndPassword(
  //     String email, String password, String name) async {
  //   try {
  //     AuthResult result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;

  //     // Create a new collection document for user with the uid
  //     await DatabaseService(uid: user.uid)
  //         .updateUserData(name, email, "student", '');
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

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
