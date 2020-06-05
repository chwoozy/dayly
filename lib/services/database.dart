import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // Collection Reference
  final CollectionReference userCollection = Firestore.instance.collection('user');

  Future updateUserData(String name, String usertype) async {
    return await userCollection.document(uid).setData({
      'name' : name,
      'usertype' : usertype,
    });
  }
}