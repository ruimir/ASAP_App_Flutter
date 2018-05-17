import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Utils/config.dart' as config;

import './Utils/RegisterData.dart';

// Add import for validate package.

class VerifyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _VerifyPageState();
}

class _LoginData {
  String numUtente = '';
  String numValidacao = '';
  String password = '';
}

class _VerifyPageState extends State<VerifyScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Validação'),
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
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (String value) {
                          this._data.numValidacao = value;
                        },
                        decoration: new InputDecoration(
                            hintText: '123456789',
                            labelText:
                                'Introduza o número que recebeu por mensagem')),
                    new TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (String value) {
                          this._data.password = value;
                        },
                        decoration: new InputDecoration(
                            hintText: 'qwerty',
                            labelText: 'Introduza a sua password')),
                    new Container(
                      width: screenSize.width,
                      child: new RaisedButton(
                        child: new Text(
                          'Registo',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            Future<RegisterData> user = verify_user(this._data);
                            user.then((RegisterData onValue) {
                              if (onValue.status == "Error") {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content:
                                        new Text("Error: " + onValue.error)));
                              } else {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content:
                                        new Text("Utilizador Validado ^_^")));
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
                    )
                  ],
                ),
              ));
        }));
  }
}

Future<RegisterData> verify_user(_LoginData login) async {
  Map body = {
    "numRegional": login.numUtente,
    "newPassword": login.password,
    "twoStep": login.numValidacao,
  };
  String con = config.connection + "webService/validacaoUser";
  final response = await http.post(
    con,
    body: body,
  );
  final responseJson = json.decode(response.body);

  return new RegisterData.fromJson(responseJson);
}
