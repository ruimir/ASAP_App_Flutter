import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './Utils/cirurgia.dart';
import './Utils/RegisterData.dart';

// Add import for validate package.

class FrontPageScreen extends StatefulWidget {
  FrontPageScreen();

  factory FrontPageScreen.forDesignTime() {
    // TODO: add arguments
    return new FrontPageScreen();
  }

  @override
  State<StatefulWidget> createState() => new _FrontPageState();
}

class _LoginData {
  String numUtente = '';
  int numeroTelemovel = 0;
  String morada = '';
  String email = '';
  DateTime dataNascimento = new DateTime.now();
}

class _FrontPageState extends State<FrontPageScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  DateTime _fromDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ASAP'),
        ),
        drawer: gaveta(context),
        body: mainContent(screenSize));
  }

  Drawer gaveta(BuildContext context) {
    return new Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: new ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(
            child: new Image.asset('images/asap_white.png'),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                // new
                // Where the linear gradient begins and ends
                begin: Alignment.topRight, // new
                end: Alignment.bottomLeft, // new
                // Add one stop for each color.
                // Stops should increase
                // from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's
                  // Colors class.
                  Colors.teal[800],
                  Colors.teal[700],
                  Colors.teal[600],
                  Colors.teal[400],
                ],
              ),
            ),
          ),
          new ListTile(
            title: new Text('Item 1'),
            leading: new Icon(Icons.menu),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          new ListTile(
            title: new Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Builder mainContent(Size screenSize) {
    return new Builder(builder: (BuildContext context) {
      return new ListView(
        padding: new EdgeInsets.all(15.0),
        children: [
          new Container(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
            child: new Text("Eventos Agendados",
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),

          ),
          new Cirugia(dataIntervencao: "12"),
          new Cirugia(dataIntervencao: "12")

        ],
      );
    });
  }
}

