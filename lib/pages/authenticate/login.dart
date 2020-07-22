import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:dayly/services/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Sign in details state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Login to Dayly',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Email Address",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (value) => value.isEmpty
                              ? 'Enter a valid email address'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RoundedButton(
                          text: "Login",
                          textColor: Colors.black,
                          color: Colors.tealAccent[400],
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _authService
                                  .loginWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Wrong email or password, please try again.';
                                  loading = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                        RoundedButton(
                          text: "New user? Sign up here!",
                          textColor: Colors.black,
                          color: Colors.grey[600],
                          press: () async {
                            Navigator.popAndPushNamed(context, '/signup');
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
                    )),
              ),
            ),
          );
  }
}
