import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './Utils/User.dart';
// Add import for validate package.

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginData {
  String numUtente = '';
  String password = '';
}

class _LoginPageState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (String value) {
                          this._data.numUtente = value;
                        }, // Use secure text for passwords.
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                            hintText: '12345',
                            labelText: 'Introduza o seu número de utente')),
                    new TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (String value) {
                          this._data.password = value;
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
                            formKey.currentState.save();
                            var numSequencial = this._data.numUtente;
                            //Sending data to ASAPs servers
                            Future<User> test = login(
                                this._data.numUtente, this._data.password);
                            test.then((User value) {
                              // Invoked when the future is completed with a value.
                              if (value.status == "OK") {
                                //User Logged on:
                                //Configuring firebase
                                _firebaseMessaging.configure(
                                  onMessage: (Map<String, dynamic> message) {
                                    print("onMessage: $message");
                                  },
                                  onLaunch: (Map<String, dynamic> message) {
                                    print("onLaunch: $message");
                                  },
                                  onResume: (Map<String, dynamic> message) {
                                    print("onResume: $message");
                                  },
                                );
                                _firebaseMessaging
                                    .requestNotificationPermissions(
                                        const IosNotificationSettings(
                                            sound: true,
                                            badge: true,
                                            alert: true));
                                _firebaseMessaging.onIosSettingsRegistered
                                    .listen((IosNotificationSettings settings) {
                                  print("Settings registered: $settings");
                                });
                                _firebaseMessaging
                                    .getToken()
                                    .then((String token) {
                                  assert(token != null);
                                  print(token);
                                  var result = firebaseLink(token);
                                  print(result);
                                });
                                _saveUser(value, int.parse(numSequencial));
                              } else {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content: new Text(
                                        'Número Sequencial ou Password Errada')));
                              }
                            }, onError: (e) {
                              print(e);
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(content: new Text("Erro!")));
                            });
                          }
                        },
                        color: Colors.teal,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    ),
                    new Container(
                      width: screenSize.width,
                      child: new FlatButton(
                        child: new Text(
                          'Recuperar Password',
                          style: new TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    )
                  ],
                ),
              ));
        }));
  }
}

Future<User> login(String numSequencial, String password) async {
  Map body = {"numSequencial": numSequencial, "password": password};
  final response =
      await http.post("http://aggro.home:3000/webService/login", body: body);
  final responseJson = json.decode(response.body);

  return new User.fromJson(responseJson);
}

//Incrementing counter after click
_saveUser(User user, int numSequencial) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwtKey', user.jwtKey);
  prefs.setInt('numSequencial', numSequencial);
}

firebaseLink(String firebaseToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  Map body = {"firebaseToken": firebaseToken};
  final response = await http.post(
      "http://aggro.home:3000/webService/firebaseLink",
      body: body,
      headers: {HttpHeaders.AUTHORIZATION: bearer});
  //final responseJson = json.decode(response.body);
}
