import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './Utils/RegisterData.dart';
import './Utils/config.dart' as config;

// Add import for validate package.

class RegisterScreen extends StatefulWidget {
  RegisterScreen();

  factory RegisterScreen.forDesignTime() {
    // TODO: add arguments
    return new RegisterScreen();
  }

  @override
  State<StatefulWidget> createState() => new _RegisterPageState();
}

class _LoginData {
  String numUtente = '';
  int numeroTelemovel = 0;
  String morada = '';
  String email = '';
  DateTime dataNascimento = new DateTime.now();
}

class _RegisterPageState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  DateTime _fromDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Registo'),
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
                new TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (!value.startsWith(new RegExp(r'9[1236]'))) {
                        return 'Por favor introduza um número português (91/92/93/96)';
                      }
                      if (value.length != 9) {
                        return 'Número de telemóvel apenas pode ter 9 dígitos!';
                      }
                    },
                    onSaved: (String value) {
                      this._data.numeroTelemovel = int.parse(value);
                    },
                    decoration: new InputDecoration(
                        hintText: 'Apenas Números Portugueses Aceites!',
                        labelText: 'Introduza o seu número de telemóvel',
                        prefixText: "+351")),
                new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (String value) {
                      this._data.email = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'ASAP@di.umimho.pt',
                        labelText: 'Introduza o seu email')),
                new TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (String value) {
                      this._data.morada = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'Gualtar, Braga',
                        labelText: 'Introduza a sua morada')),
                new _DateTimePicker(
                    labelText: 'Data de Nascimento',
                    selectedDate: _fromDate,
                    selectDate: (DateTime date) {
                      setState(() {
                        this._data.dataNascimento = date;
                        _fromDate = date;
                      });
                    }),
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
                        Future<RegisterData> user = register_user(this._data);
                        user.then((RegisterData onValue) {
                          if (onValue.status == "Error") {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("Erro: " + onValue.error)));
                          } else {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("Utilizador Registado 🤩")));
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

/*Future<User> login(String numSequencial, String password) async {
  Map body = {"numSequencial": numSequencial, "password": password};
  final response =
      await http.post("http://aggro.home:3000/webService/login", body: body);
  final responseJson = json.decode(response.body);

  return new User.fromJson(responseJson);
}*/

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1900, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}

Future<RegisterData> register_user(_LoginData login) async {
  Map body = {
    "numRegional": login.numUtente,
    "numTelemovel": ("+351") + login.numeroTelemovel.toString(),
    "dataNascimento": login.dataNascimento.toIso8601String().substring(0, 10),
    "email": login.email,
    "morada": login.morada
  };
  String con = config.connection + "webService/registoUser";
  final response = await http.post(
    con,
    body: body,
  );
  final responseJson = json.decode(response.body);

  return new RegisterData.fromJson(responseJson);
}
