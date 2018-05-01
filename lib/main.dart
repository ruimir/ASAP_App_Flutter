import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'login.dart';

void main() => runApp(new mainMenu());

class mainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.teal,
        ),
        title: 'ASAP',
        home: new menu());
  }
}

class menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ASAP'),
      ),
      body: new ListView(
        children: [
          new Image.asset(
            'images/ASAPlogo.png',
            width: 100.0,
            height: 240.0,
          ),
          new Center(
            child: new Container(
              width: 150.0,
              margin: const EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Iniciar Sessão'),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SecondScreen()),
                  );
                  // Perform some action
                },
              ),
            ),
          ),
          new Center(
            child: new Container(
              width: 150.0,
              margin: const EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Registo'),
                onPressed: () {
                  // Perform some action
                },
              ),
            ),
          ),
          new Center(
            child: new Container(
              width: 150.0,
              margin: const EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Validação'),
                onPressed: () {
                  // Perform some action
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
