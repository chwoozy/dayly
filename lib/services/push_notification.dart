import 'dart:async';
import 'dart:convert';

import 'package:dayly/models/user.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/models/notification_manager.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  User user;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  String identifier;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context);
    getIdentifier();
    saveDeviceToken();

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    });
  }

  getIdentifier() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.id.toString();
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor;
      }
    } on PlatformException {
      print("Failed to get device platform version");
    }
  }

  saveDeviceToken() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("IOS Settings registered: $settings");
      });
    }
    await _fcm.getToken().then((token) {
      print('Firebase Token');
      _db
          .collection('user')
          .document(user.uid)
          .collection('tokens')
          .document(identifier)
          .setData({
        'identifier': identifier,
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    });
  }

  Future<bool> callOnFcmApiSendPushNotifications(List<String> userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": 'NewTextTitle',
        "body": 'NewTextBody',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'AAAARFiPG9I:APA91bEQBMwZU-Tf2lWUk98ObEABt4hJ8Gbo209uBhQB1v46YPwAxdiO3OP5t4HU9MsKR1HTWXh7oGVqgJ0wvb4fOkV8lIztypM_kFxas3VMssOCTQdeoF66wTZ72UeF77MIsbIc3e2f',
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  // /// Get the token, save it to the database for current user
  // saveDeviceToken() async {
  //   // Get the current user
  //   String uid = 'jeffd23';
  //   // FirebaseUser user = await _auth.currentUser();

  //   // Get the token for this device
  //   String fcmToken = await _fcm.getToken();

  //   // Save it to Firestore
  //   if (fcmToken != null) {
  //     var tokens = _db
  //         .collection('user')
  //         .document(uid)
  //         .collection('tokens')
  //         .document(fcmToken);

  //     await tokens.setData({
  //       'token': fcmToken,
  //       'createdAt': FieldValue.serverTimestamp(), // optional
  //       'platform': Platform.operatingSystem // optional
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
