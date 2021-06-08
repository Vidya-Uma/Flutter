import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/images/image.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Students can share the details of the events to our group of students. And also, the student can find the details of events whereas the faculty can share the details of the events and  also share useful information like notes with particular students.',
                  style: TextStyle(fontSize: 15.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
