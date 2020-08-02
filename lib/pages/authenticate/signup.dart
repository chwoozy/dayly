import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/outlined_button.dart';
import 'package:dayly/components/primary_button.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:dayly/services/auth.dart';

class SignUp extends StatefulWidget {
  final Function notifyLanding;

  SignUp({this.notifyLanding});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Sign in details state
  String email = '';
  String password = '';
  String name = '';
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
                    "Sign up to Dayly",
                    style: TextStyle(fontSize: textQuery * 35),
                  ),
                  SizedBox(
                    height: sizeQuery.height * 0.02,
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
                            width: sizeQuery.width * 0.1,
                            child: Icon(Icons.person, size: textQuery * 20)),
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
                                labelText: "Your Name",
                                labelStyle: TextStyle(
                                  fontSize: textQuery * 18,
                                  color: Colors.grey,
                                )),
                            validator: (value) => value.length < 1
                                ? 'Name cannot be blank'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sizeQuery.height * 0.01,
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
                            validator: (value) => EmailValidator.validate(value)
                                ? null
                                : 'Enter a valid email address',
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
                    height: sizeQuery.height * 0.01,
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
                    title: "Sign up",
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _authService
                            .signUpWithEmailAndPassword(email, password, name);
                        if (result == null) {
                          setState(() {
                            error = 'Email address is already in use!';
                            loading = false;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: sizeQuery.height * 0.02,
                  ),
                  OutlinedButton(
                    title: "Back to login",
                    onTap: () async {
                      widget.notifyLanding(1);
                    },
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
