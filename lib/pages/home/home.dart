import 'package:dayly/components/constants.dart';
import 'package:dayly/pages/profile/profile.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dayly/services/database.dart';
import 'package:provider/provider.dart';
import 'package:dayly/pages/models/user.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatelessWidget {

  final AuthService _authService = AuthService();
  final User user;

  Home({ this.user });

  @override
  Widget build(BuildContext context) {
    
    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: user.uid).userData,
      child: Scaffold(
        backgroundColor: primaryBackgroundColor,
        // appBar: AppBar(
        //   title: Text('Home'),
        //   backgroundColor: primaryPurple,
        //   elevation: 0.0,
        //   actions: <Widget>[
        //     IconButton(
        //       padding: EdgeInsets.symmetric(horizontal: 20.0),
        //       icon: Icon(Icons.exit_to_app),
        //       onPressed: () async {
        //         await _authService.signOut();
        //       },
        //     )
        //   ],
        // ),
        body: Profile(),
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          index: 0,
          backgroundColor: primaryBackgroundColor,
          color: secondaryBackgroundColor,
          items: <Widget>[
            Icon(Icons.event, size: 30, color: primaryPurple),
            Icon(Icons.assignment, size: 30, color: primaryPurple),
            Icon(Icons.perm_identity, size: 30, color: primaryPurple),
          ],
          animationDuration: Duration(
            milliseconds: 200,
          ),
          onTap: (index) {
            //Handle button tap
          },
        )
      ),
    );
  }
}