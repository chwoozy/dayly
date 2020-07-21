import 'package:flutter/material.dart';
import 'package:dayly/components/constants.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:dayly/services/auth.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 200,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/landing-bar.png'),
                          )),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 10.0),
              Center(
                child: Image.asset(
                  'assets/images/landing-main.png',
                  scale: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Hey there, \nWelcome to Dayly!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    )),
              ),
              SizedBox(height: 15.0),
              RoundedButton(
                text: "LOGIN WITH GOOGLE",
                color: Colors.tealAccent[400],
                textColor: Colors.black,
                press: () async {
                  await _authService.signInWithGoogle();
                  // Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          )),
    );
  }
}
