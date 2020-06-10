import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/pages/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // Collection Reference
  final CollectionReference userCollection = Firestore.instance.collection('user');

  Future updateUserData(String name, String email, String type, String imageUrl) async {
    return await userCollection.document(uid).setData({
      'name' : name,
      'email' : email,
      'type' : type,
      'imageUrl' : imageUrl,
    });
  }

  // Get User Data Stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

  // User Data from Snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      type: snapshot.data['type'],
      imageUrl: snapshot.data['imageUrl'],
    );
  }
}