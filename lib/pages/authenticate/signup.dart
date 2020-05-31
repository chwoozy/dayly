import 'package:dayly/components/constants.dart';
import 'package:dayly/components/rounded-button.dart';
import 'package:flutter/material.dart';
import 'package:dayly/services/auth.dart';

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
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
          'Create Your Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                validator: (value) => value.length < 6 ?  'Enter a password of 7 characters or more' : null,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(height: 40.0,),
              RoundedButton(
                color: primaryPurple,
                text: 'SIGN UP',
                press: () async {
                  if(_formKey.currentState.validate()) {
                    dynamic result = await _authService.signUpWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = 'Please use a valid email address');
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