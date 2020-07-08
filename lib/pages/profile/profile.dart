import 'dart:io';
import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/auth.dart';
import 'package:dayly/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Form States
  String _displayName = '';
  String _email = '';
  String _uid = '';
  String _photoUrl = '';
  bool loading = false;
  bool updating = false;
  bool processing = false;
  String _errorMsg = '';
  File _uploadedImage;
  final _picker = ImagePicker();

  Future getImage() async {
    final _pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() => _uploadedImage = File(_pickedImage.path));
  }

  Future uploadImage(File file) async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('user/assets/profilepic/$_uid.png');

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_uploadedImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print('Upload Complete');
    _photoUrl = await taskSnapshot.ref.getDownloadURL();
    print(_photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Initialise Variables
            _displayName = snapshot.data.displayName;
            _email = snapshot.data.email;
            _uid = snapshot.data.uid;
            _photoUrl = snapshot.data.photoUrl;

            return loading
                ? Loading()
                : Scaffold(
                    backgroundColor: primaryBackgroundColor,
                    body: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 200,
                              child: Stack(children: <Widget>[
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: primaryPurple,
                                    // boxShadow: [BoxShadow(blurRadius: 5.0)],
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(49)),
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: primaryBackgroundColor),
                                        color: primaryBackgroundColor,
                                      ),
                                      height: 140,
                                      width: 140,
                                      child: Container(
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: _uploadedImage != null
                                                ? FileImage(_uploadedImage)
                                                : _photoUrl == ''
                                                    ? AssetImage(
                                                        'assets/images/avatar.png')
                                                    : NetworkImage(_photoUrl),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black, width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 145,
                                  right: 140,
                                  child: Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black, width: 2.0),
                                      color: Colors.white,
                                    ),
                                    // User Profile Image
                                    child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      icon: Icon(Icons.create),
                                      onPressed: getImage,
                                    ),
                                  ),
                                )
                              ]),
                            ),
                            // SizedBox(height: 10.0,),
                            Center(
                              child: Text(_displayName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                  )),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                                height: size.height - 450,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Email Address',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          _email,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            height: 2,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Password',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                        TextFormField(
                                          obscureText: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              //TODO: Change Password
                                            });
                                          },
                                          decoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              hintText:
                                                  'Click to change password'),
                                        ),
                                        updating
                                            ? Text(
                                                'Your profile has been updated.',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ))
                                            : SizedBox(height: 10),
                                      ]),
                                )),
                            Center(
                              child: RoundedButton(
                                color: primaryPurple,
                                text: 'Save Changes',
                                press: () async {
                                  print(_email);
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    if (_uploadedImage != null) {
                                      await uploadImage(_uploadedImage);
                                    }
                                    DatabaseService(uid: _uid)
                                        .updateUserData(
                                            _email, _displayName, _photoUrl)
                                        .whenComplete(() async {
                                      setState(() {
                                        loading = false;
                                        updating = true;
                                      });
                                    });
                                  }
                                },
                                textColor: Colors.white,
                              ),
                            ),
                            processing
                                ? Center(child: CircularProgressIndicator())
                                : Center(
                                    child: RoundedButton(
                                      color: Colors.grey,
                                      text: 'Import from Google Calendar',
                                      press: () async {
                                        setState(() {
                                          processing = true;
                                        });
                                        try {
                                          await _authService
                                              .getEvents(snapshot.data.uid);
                                          print("Success!");
                                        } catch (e) {
                                          print(e);
                                        }
                                        setState(() {
                                          processing = false;
                                        });
                                      },
                                      textColor: Colors.black,
                                    ),
                                  ),
                          ]),
                    ),
                  );
          } else {
            return Loading();
          }
        });
  }
}
