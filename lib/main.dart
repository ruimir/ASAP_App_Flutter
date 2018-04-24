import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new mainMenu(),
    );
  }
}

class mainMenu extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(
      title: new Text('Welcome to Flutter!'),
    ),
      body: new Center(
        child: new Text('Hello World'),
      ),);
  }
}



