import 'package:dayly/components/constants.dart';
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

  //Sign in details state
  String email = '';
  String password = '';
  String error = '';

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0.0,
        title: Text(
          'Login to Dayly',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        ),
      ),
      body: Container(
        padding:  EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                validator: (value) => value.isEmpty ?  'Enter a valid email address' : null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true, 
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(height: 40.0,),
              RoundedButton(
                text: "LOGIN",
                color: primaryPurple,
                press: () async {
                  if(_formKey.currentState.validate()) {
                    dynamic result = await _authService.loginWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = 'Wrong email or password, please try again.');
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
          ],
          )
        ),
      ),
    );
  }
}