import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import './Utils/cirurgia.dart';
import './Utils/exame.dart';
import './Utils/consulta.dart';
import 'package:intl/intl.dart';

import './Utils/config.dart' as config;
import './Utils/gaveta.dart' as gaveta;

var formatter = new DateFormat('dd-MM-yyyy');

// Add import for validate package.

class PerfilScreen extends StatefulWidget {
  PerfilScreen();

  factory PerfilScreen.forDesignTime() {
    // TODO: add arguments
    return new PerfilScreen();
  }

  @override
  State<StatefulWidget> createState() => new _PerfilState();
}

class _PerfilState extends State<PerfilScreen> {
  String temp = "";
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Perfil Utilizador'),
          elevation: 0.1,
        ),
        drawer: gaveta.gaveta(context),
        body: pagina());
  }

  FutureBuilder pagina() {
    return new FutureBuilder<dynamic>(
      future: getPerfil(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //return new Text(snapshot.data["cirugias"].toString());
          return new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new DrawerHeader(
                    child: new Image.asset('images/asap_new_white.png'),
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
                  ))
                ],
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title:
                    Text("Número: " + snapshot.data["n_telemovel"].toString()),
                trailing: IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    {
                      numeroDialog<String>(
                          context: context,
                          child: new AlertDialog(
                              content: new Container(
                                height: 100.0,
                                width: 350.0,
                                child: new Column(
                                  children: <Widget>[
                                    Text("Novo Número"),
                                    new Form(
                                        key: this.formKey,
                                        child: new TextFormField(
                                          autofocus: true,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            if (!value.startsWith(
                                                new RegExp(r'9[1236]'))) {
                                              return 'Por favor introduza um número português (91/92/93/96)';
                                            }
                                            if (value.length != 9) {
                                              return 'Número de telemóvel apenas pode ter 9 dígitos!';
                                            }
                                          },
                                          decoration: new InputDecoration(
                                              labelText: 'Número de telemóvel',
                                              prefixText: "+351"),
                                          keyboardType: TextInputType.number,

                                          onSaved: (String value) {
                                            this.temp = "+351" + value;
                                          },
                                          // Use secure text for passwords.
                                          // Use email input type for emails.
                                        ))
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.pop(context, null);
                                    }),
                                new FlatButton(
                                    child: const Text('Guardar'),
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        Navigator.pop(context, this.temp);
                                      }
                                    })
                              ]));
                    }
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Email: " + snapshot.data["email"].toString()),
                trailing: IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    {
                      emailDialog<String>(
                          context: context,
                          child: new AlertDialog(
                              content: new Container(
                                height: 90.0,
                                width: 350.0,
                                child: new Column(
                                  children: <Widget>[
                                    Text("Novo Email"),
                                    new Form(
                                        key: this.formKey,
                                        child: new TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                            },
                                            onSaved: (String value) {
                                              this.temp = value;
                                            },
                                            decoration: new InputDecoration(
                                              hintText: 'ASAP@di.umimho.pt',
                                            )))
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.pop(context, null);
                                    }),
                                new FlatButton(
                                    child: const Text('Guardar'),
                                    onPressed: () {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        Navigator.pop(context, this.temp);
                                      }
                                    })
                              ]));
                    }
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Morada: " + snapshot.data["morada"].toString()),
                trailing: IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    moradaDialog<String>(
                        context: context,
                        child: new AlertDialog(
                            content: new Container(
                              height: 90.0,
                              width: 350.0,
                              child: new Column(
                                children: <Widget>[
                                  Text("Nova Morada"),
                                  new Form(
                                      key: this.formKey,
                                      child: new TextFormField(
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                          },
                                          onSaved: (String value) {
                                            this.temp = value;
                                          },
                                          decoration: new InputDecoration(
                                            hintText: 'Gualtar, Braga',
                                          )))
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.pop(context, null);
                                  }),
                              new FlatButton(
                                  child: const Text('Guardar'),
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      Navigator.pop(context, this.temp);
                                    }
                                  })
                            ]));
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.cake),
                title: Text("Data Nascimento: " +
                    formatter
                        .format(DateTime
                            .parse(snapshot.data["dataNascimento"].toString()))
                        .toString()),
              ),
              Container(
                width: 200.0,
                child: RaisedButton(
                  color: Colors.teal,
                  child: const Text(
                    'Mudar Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    confirmarMudarPassword<String>(
                        context: context,
                        child: new AlertDialog(
                            title: Text("Mudar Password"),
                            content: Text(
                                "Pode pedir para mudar a password. Contudo, a sua conta vai ficar pendente de ativação. Pretende continuar com o processo?"),
                            actions: <Widget>[
                              new FlatButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.pop(context, null);
                                  }),
                              new FlatButton(
                                  child: const Text('Confirmar',
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.pop(context, "Mudar");
                                  })
                            ]));
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }

        // By default, show a loading spinner
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
    );
  }
}

Future<dynamic> getPerfil() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/user";
  final response =
      await http.get(con, headers: {HttpHeaders.AUTHORIZATION: bearer});
  var responseJson = json.decode(response.body);

  return (responseJson);
}

void numeroDialog<T>({BuildContext context, Widget child}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  ).then<void>((value) {
    // The value passed to Navigator.pop() or null.
    if (value != null) {
      Future<dynamic> status = setNumero(value);
      status.then((dynamic onValue) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("Número Atualizado com Sucesso!")));
        Scaffold.of(context).setState(() => {});
      }, onError: (e) {
        print(e);
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Verifique a sua conexão e tente novamente")));
      });
    }
  });
}

void emailDialog<T>({BuildContext context, Widget child}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  ).then<void>((value) {
    // The value passed to Navigator.pop() or null.
    if (value != null) {
      Future<dynamic> status = setEmail(value);

      status.then((dynamic onValue) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("Email Atualizado com Sucesso!")));
        Scaffold.of(context).setState(() => {});
      }, onError: (e) {
        print(e);
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Verifique a sua conexão e tente novamente")));
      });
    }
  });
}

void moradaDialog<T>({BuildContext context, Widget child}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  ).then<void>((value) {
    // The value passed to Navigator.pop() or null.
    if (value != null) {
      Future<dynamic> status = setMorada(value);

      status.then((dynamic onValue) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("Morada Atualizada com Sucesso!")));
        Scaffold.of(context).setState(() => {});
      }, onError: (e) {
        print(e);
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Verifique a sua conexão e tente novamente")));
      });
    }
  });
}

Future<dynamic> setMorada(String morada) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/updateMorada";
  Map body = {"morada": morada};
  final response = await http
      .post(con, body: body, headers: {HttpHeaders.AUTHORIZATION: bearer});
  var responseJson = json.decode(response.body);

  return (responseJson);
}

Future<dynamic> setEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/updateEmail";
  Map body = {"email": email};
  final response = await http
      .post(con, body: body, headers: {HttpHeaders.AUTHORIZATION: bearer});
  var responseJson = json.decode(response.body);

  return (responseJson);
}

Future<dynamic> setNumero(String numero) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/updateNumero";
  Map body = {"numero": numero};
  final response = await http
      .post(con, body: body, headers: {HttpHeaders.AUTHORIZATION: bearer});
  var responseJson = json.decode(response.body);

  return (responseJson);
}

void confirmarMudarPassword<T>({BuildContext context, Widget child}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  ).then<void>((value) {
    // The value passed to Navigator.pop() or null.
    if (value == "Mudar") {
      Future<dynamic> result = passwordReset();
      result.then((onValue) {
        if (onValue == true) {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Pedido enviado com sucesso")));
          Navigator.of(context).pushReplacementNamed('/boot');
        } else {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Erro durante o pedido")));
        }
      });
    }
  });
}

Future<bool> passwordReset() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getInt('numSequencial').toString();
  assert(key != null);
  String con = config.connection + "webService/resetRequest";
  Map body = {"numRegional": key};
  final response = await http.post(con, body: body);
  var responseJson = json.decode(response.body);
  if (responseJson["status"] == "Succsess") {
    prefs.setString("jwtKey", null);
    prefs.setInt("numSequencial", null);
    return true;
  } else {
    print(responseJson);
    return false;
  }
}
