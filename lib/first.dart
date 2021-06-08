import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_vidya/package/dashboard.dart';

import 'package:flutter_app_vidya/package/sign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_button/animated_button.dart';

import 'package/sign.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  final formKey = new GlobalKey<FormState>();
  String email;
  String password;
  bool showErrorMessage = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result.user.toString());
    } catch (e) {}
  }

  Future<dynamic> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('C_Chatz'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Text(
                'Student Login',
                style: new TextStyle(
                  fontSize: 25,
                ),
              ),
              new TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Enter a valid email!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => value.length < 6
                    ? 'password must be more than 6 chars'
                    : null,
                // onSaved: (value) => password = value,
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedButton(
                        child: Text('Login'),
//                   onPressed: validateAndSubmit,
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            UserCredential credential =
                                await loginWithEmailAndPassword(
                                    email, password);
                            print(email);
                            print(password);
                            print(credential);
                            if (credential != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => (Dashboard()),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AnimatedButton(
                        child: Text('Sign Up'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => (SignUp()),
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
