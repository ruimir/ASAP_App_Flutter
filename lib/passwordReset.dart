import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './Utils/RegisterData.dart';
import './Utils/config.dart' as config;

// Add import for validate package.

class ResetScreen extends StatefulWidget {
  ResetScreen();

  factory ResetScreen.forDesignTime() {
    // TODO: add arguments
    return new ResetScreen();
  }

  @override
  State<StatefulWidget> createState() => new _ResetPageState();
}

class _LoginData {
  String numUtente = '';
}

class _ResetPageState extends State<ResetScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Reposição de Password'),
        ),
        body: loginForm(screenSize));
  }

  Builder loginForm(Size screenSize) {
    return new Builder(builder: (BuildContext context) {
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
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Reset de Password',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        Future<RegisterData> user = register_user(this._data);
                        user.then((RegisterData onValue) {
                          if (onValue.status == "Error") {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("Erro: " + onValue.error)));
                          } else {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text(
                                    "Pedido Recebido. Aguade pela confirmação pelo Administrador.")));
                          }
                        }, onError: (e) {
                          print(e);
                          Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(
                                  "Verifique a sua conexão e tente novamente")));
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
    });
  }
}

Future<RegisterData> register_user(_LoginData login) async {
  Map body = {
    "numRegional": login.numUtente,
  };
  String con = config.connection + "webService/resetRequest";
  final response = await http.post(
    con,
    body: body,
  );
  final responseJson = json.decode(response.body);

  return new RegisterData.fromJson(responseJson);
}
