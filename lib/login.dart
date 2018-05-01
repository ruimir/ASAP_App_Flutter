import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:validate/validate.dart'; // Add import for validate package.

class SecondScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginPageState extends State<SecondScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new Builder(builder: (BuildContext context) {
          return new Container(
              padding: new EdgeInsets.all(20.0),
              child: new Form(
                key: this.formKey,
                child: new ListView(
                  children: <Widget>[
                    new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                            hintText: 'you@example.com',
                            labelText: 'Introduza o seu email')),
                    new TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (String value) {
                          this._data.email = value;
                        }, // Use secure text for passwords.
                        decoration: new InputDecoration(
                            hintText: 'Password',
                            labelText: 'Intoduza a sua password')),
                    new Container(
                      width: screenSize.width,
                      child: new RaisedButton(
                        child: new Text(
                          'Login',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (formKey.currentState.validate()) {
                            // If the form is valid, we want to show a Snackbar
                            //TODO: Net Code
                            Scaffold.of(context).showSnackBar(
                                new SnackBar(content: new Text('COMING SOON')));
                          }
                        },
                        color: Colors.teal,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    )
                  ],
                ),
              ));
        }));
  }

  void test() {}
}
