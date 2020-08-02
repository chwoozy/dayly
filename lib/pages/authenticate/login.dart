import 'package:dayly/components/outlined_button.dart';
import 'package:dayly/components/primary_button.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  final Function notifyLanding;

  Login({@required this.notifyLanding});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Sign in details state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size sizeQuery = MediaQuery.of(context).size;
    double textQuery = MediaQuery.of(context).textScaleFactor;

    return Container(
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Login To Continue",
                    style: TextStyle(fontSize: textQuery * 35),
                  ),
                  SizedBox(
                    height: sizeQuery.height * 0.05,
                  ),
                  Container(
                    height: sizeQuery.height * 0.08,
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeQuery.width * 0.05),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding:
                                EdgeInsets.only(left: sizeQuery.width * 0.02),
                            width: sizeQuery.width * 0.1,
                            child: Icon(Icons.mail, size: textQuery * 20)),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: textQuery * 20,
                            ),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                labelText: "Email Address",
                                labelStyle: TextStyle(
                                  fontSize: textQuery * 18,
                                  color: Colors.grey,
                                )),
                            validator: (value) => value.isEmpty
                                ? 'Enter a valid email address'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: sizeQuery.height * 0.08,
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeQuery.width * 0.05),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding:
                                EdgeInsets.only(left: sizeQuery.width * 0.02),
                            width: sizeQuery.width * 0.1,
                            child: Icon(Icons.vpn_key, size: textQuery * 20)),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: textQuery * 20,
                            ),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  fontSize: textQuery * 18,
                                  color: Colors.grey,
                                )),
                            obscureText: true,
                            validator: (value) => value.length < 7
                                ? 'Enter a password of 7 characters or more'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  PrimaryButton(
                      title: "Login",
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _authService
                              .loginWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error =
                                  'Wrong email or password, please try again.';
                            });
                          }
                        }
                      }),
                  SizedBox(
                    height: sizeQuery.height * 0.02,
                  ),
                  OutlinedButton(
                    title: "Create new account",
                    onTap: () async {
                      widget.notifyLanding(2);
                    },
                  ),
                  SizedBox(
                    height: sizeQuery.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _authService.signInWithGoogle();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(
                            horizontal: sizeQuery.width * 0.08),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.google,
                                size: textQuery * 20,
                              ),
                              SizedBox(
                                width: sizeQuery.width * 0.03,
                              ),
                              Text(
                                "Login with Google",
                                style: TextStyle(fontSize: textQuery * 25),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
