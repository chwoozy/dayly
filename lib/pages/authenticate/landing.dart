import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final AuthService _authService = AuthService();
  List<String> randomLanding = [
    'assets/images/landing-logo-productivity.svg',
    'assets/images/landing-logo-focus.svg',
    'assets/images/landing-logo-program.svg',
  ];
  Random rand = Random();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int max = randomLanding.length;
    int r = rand.nextInt(max);
    print(r);

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            height: size.height * 0.2,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/landing-bar.png'),
              )),
            )),
        SizedBox(height: size.height * 0.05),
        Center(
          child: SvgPicture.asset(
            randomLanding[r],
            height: size.height * 0.3,
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hey there, \nWelcome to Dayly!',
                      style: TextStyle(
                        fontSize: size.aspectRatio * 70,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              )),
        ),
        SizedBox(height: size.height * 0.05),
        RoundedButton(
          text: "LOGIN WITH GOOGLE",
          color: Colors.tealAccent[400],
          textColor: Colors.black,
          press: () async {
            await _authService.signInWithGoogle();
            // Navigator.pushNamed(context, '/login');
          },
        ),
        RoundedButton(
          text: "LOGIN WITH EMAIL",
          color: Theme.of(context).accentColor,
          textColor: Colors.black,
          press: () async {
            Navigator.pushNamed(context, '/login');
          },
        ),
      ],
    ));
  }
}
