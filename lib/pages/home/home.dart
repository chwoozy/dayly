import 'package:dayly/components/constants.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: Text('Your Profile'),
        backgroundColor: primaryPurple,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Welcome back, \nUser',
              style: TextStyle(
                fontWeight:  FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      )
    );
  }
}