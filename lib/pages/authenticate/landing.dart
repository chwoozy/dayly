import 'dart:math';

import 'package:dayly/pages/authenticate/login.dart';
import 'package:dayly/pages/authenticate/signup.dart';
import 'package:flutter/material.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<String> randomLanding = [
    'assets/images/landing-1.png',
    'assets/images/landing-2.png',
  ];
  Random rand = Random();
  int _pageState = 0;
  double _windowWidth;
  double _windowHeight;
  double _loginYOffset;
  double _loginXOffset;
  double _signupYOffset;
  double _signupHeight;
  double _loginWidth;
  double _loginHeight;
  double _loginOpacity = 1;
  double _headingMargin;

  setPageState(int page) {
    setState(() {
      _pageState = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sizeQuery = MediaQuery.of(context).textScaleFactor;
    int max = randomLanding.length;
    int r = rand.nextInt(max);
    var _backgroundColor = Theme.of(context).canvasColor;
    _windowWidth = mediaQuery.width;
    _windowHeight = mediaQuery.height;

    _loginHeight = _windowHeight - (mediaQuery.height * 0.32);
    _signupHeight = _windowHeight - (mediaQuery.height * 0.38);

    switch (_pageState) {
      case 0:
        _backgroundColor = Theme.of(context).canvasColor;
        _loginYOffset = _windowHeight;
        _loginXOffset = 0;
        _loginWidth = _windowWidth;
        _signupYOffset = _windowHeight;
        _loginOpacity = 1;
        _headingMargin = mediaQuery.height * 0.08;
        break;
      case 1:
        _backgroundColor = Colors.indigoAccent[700];
        _loginYOffset = mediaQuery.height * 0.32;
        _loginXOffset = 0;
        _loginWidth = _windowWidth;
        _signupYOffset = _windowHeight;
        _loginOpacity = 1;
        _headingMargin = mediaQuery.height * 0.05;
        break;
      case 2:
        _backgroundColor = Colors.blue[900];
        _loginYOffset = mediaQuery.height * 0.33;
        _loginXOffset = mediaQuery.width * 0.05;
        _loginWidth = _windowWidth - (mediaQuery.width * 0.1);
        _signupYOffset = mediaQuery.height * 0.38;
        _loginOpacity = 0.9;
        _headingMargin = mediaQuery.height * 0.04;
        break;
    }

    return Scaffold(
        body: Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(
            milliseconds: 1000,
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          color: _backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _pageState = 0;
                  });
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      AnimatedContainer(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(
                          milliseconds: 1000,
                        ),
                        margin: EdgeInsets.only(top: _headingMargin),
                        child: Text(
                          "Plan Out Your Day",
                          style: TextStyle(
                            fontSize: sizeQuery * 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: mediaQuery.height * 0.02,
                          left: mediaQuery.width * 0.05,
                          right: mediaQuery.width * 0.05,
                        ),
                        child: Text(
                          "Dayly helps you plan your day!  Tell us your events, what you need done, and we'll handle the rest.",
                          style: TextStyle(fontSize: sizeQuery * 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: mediaQuery.height * 0.4,
                padding:
                    EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.1),
                child: Image.asset(
                  randomLanding[r],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_pageState != 0) {
                      _pageState = 0;
                    } else {
                      _pageState = 1;
                    }
                  });
                },
                child: Container(
                  child: Center(
                      child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: sizeQuery * 20,
                    ),
                  )),
                  margin: EdgeInsets.all(mediaQuery.width * 0.1),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.indigoAccent[700],
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              // RoundedButton(
              //   text: "LOGIN WITH GOOGLE",
              //   color: Colors.tealAccent[400],
              //   textColor: Colors.black,
              //   press: () async {
              //     await _authService.signInWithGoogle();
              //     // Navigator.pushNamed(context, '/login');
              //   },
              // ),
              // RoundedButton(
              //   text: "LOGIN WITH EMAIL",
              //   color: Theme.of(context).accentColor,
              //   textColor: Colors.black,
              //   press: () async {
              //     Navigator.pushNamed(context, '/login');
              //   },
              // ),
            ],
          ),
        ),
        AnimatedContainer(
          padding: EdgeInsets.all(32),
          height: _loginHeight,
          width: _loginWidth,
          duration: Duration(
            milliseconds: 1000,
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor.withOpacity(_loginOpacity),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          child: Login(
            notifyLanding: setPageState,
          ),
        ),
        AnimatedContainer(
            padding: EdgeInsets.only(top: 22, left: 22, right: 22),
            height: _signupHeight,
            duration: Duration(
              milliseconds: 1000,
            ),
            curve: Curves.fastLinearToSlowEaseIn,
            transform: Matrix4.translationValues(0, _signupYOffset, 1),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: SignUp(
              notifyLanding: setPageState,
            )),
      ],
    ));
  }
}
