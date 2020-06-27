import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/pages/models/event.dart';
import 'package:dayly/pages/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference userCollection =
      Firestore.instance.collection('user');

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
      'eventDate': event.eventDate,
    });
  }

  Future<DocumentSnapshot> get checkUser {
    return userCollection.document(uid).get();
  }

  // Get User Data Stream
  Stream<UserData> get userData {
    return userCollection
        .document(uid)
        .collection('profile')
        .document('userinfo')
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  // Get List of Event
  Future<List<Event>> get allEvents async {
    final QuerySnapshot result =
        await userCollection.document(uid).collection('event').getDocuments();
    return result.documents.map(_eventFromSnapshot).toList();
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
      eventDate: snapshot.data['eventDate'].toDate(),
    );
  }
}
