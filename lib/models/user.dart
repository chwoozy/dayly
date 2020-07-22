class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final String method;

  UserData(
      {this.uid, this.email, this.displayName, this.photoUrl, this.method});
}
