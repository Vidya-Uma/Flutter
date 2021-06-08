import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_vidya/package/about.dart';
import 'package:flutter_app_vidya/package/postmsg.dart';

import 'package:flutter_app_vidya/newsignup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class Home extends StatelessWidget {
  Home({this.uid});

  final String uid;
  final String title = "Home";
  TextEditingController nameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String textid = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then(
                (res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                      (Route<dynamic> route) => false);
                },
              );
            },
          ),
        ],
      ),
      body: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 24.0),
              TextFormField(
                controller: contentController,
                autofocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your message',
                  helperText: 'description',
                ),
                maxLines: 4,
                maxLength: 200,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Some message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48.0),
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                    hintText: 'Enter your name', helperText: 'name'),
                controller: nameController,
                onChanged: (value) {
                  textid = value;
                },
              ),
              Spacer(),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure to submit this post?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              List<String> content =
                                  preferences.getStringList('posts') ??
                                      List<String>();
                              content.add(contentController.text +
                                  '@@' +
                                  nameController.text +
                                  "@@" +
                                  "${DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now())}");
                              await preferences.setStringList('posts', content);
                              nameController.text = '';
                              contentController.text = '';
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: NavigateDrawer(uid: this.uid),
    );
  }
}

class NavigateDrawer extends StatefulWidget {
  final String uid;

  NavigateDrawer({Key key, this.uid}) : super(key: key);

  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("Users")
                    .child(widget.uid)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value['email']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            accountName: FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("Users")
                    .child(widget.uid)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value['name']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.home, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Home'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.description, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About()),
              );
              print(widget.uid);
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.logout, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IntroScreen()),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.message, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Post'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Post(
                            userId: widget.uid,
                          )));
            },
          ),
        ],
      ),
    );
  }
}
