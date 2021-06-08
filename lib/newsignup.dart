import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'newemail.dart';
import 'newemaillogin.dart';

class SignUp extends StatelessWidget {
  final String title = "Sign Up";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                height: 48,
                width: double.infinity,
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Meet Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'Roboto')),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Email,
                  text: "Sign up with Email",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailSignUp()),
                    );
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: () {
                    print('hello');
                    linkGoogleAndTwitter();
                  },
                )),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Text("Log In Using Email",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLogIn()),
                  );
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

Future<void> linkGoogleAndTwitter() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final UserCredential googleUserCredential =
      await FirebaseAuth.instance.signInWithCredential(googleCredential);
}
