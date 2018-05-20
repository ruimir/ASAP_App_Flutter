import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Exame extends StatelessWidget {
  //"dta_marcacao": "23-04-2018",
  //"dta_registo": "13-12-2017",
  //"cod_modulo": "RAD",
  //"designacao": "ECOGRAFIA  ART + CUT D.PINA V. + D.PEDRO C.",
  //"hora_marcacao": "16:45:00"

  final String dataMarcacao, dataRegisto, codModulo, designacao, horaMarcacao;
  final Widget child;

  const Exame({
    Key key,
    this.dataMarcacao,
    this.dataRegisto,
    this.codModulo,
    this.designacao,
    this.horaMarcacao,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.fromLTRB(9.0, 4.0, 9.0, 4.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          new Row(children: <Widget>[

            new Text("Exame " + this.codModulo,
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ))
          ]),
          new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text("Data: " + this.dataMarcacao),
                    new Text("Hora: " + this.horaMarcacao),
                  ])),
          new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(this.designacao)
                  ]))
        ],
      ),
    );
  }
}
