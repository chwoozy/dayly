import 'package:flutter/material.dart';
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
                  height: size.height * 0.3,
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
              SizedBox(height: size.height * 0.01),
              Center(
                child: Image.asset(
                  'assets/images/landing-main.png',
                  scale: 1.5,
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
                              fontSize: 40,
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
          )),
    );
  }
}
