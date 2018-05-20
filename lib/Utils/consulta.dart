import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Consulta extends StatelessWidget {
  //"dataConsulta": "19-04-2018",
  //"hora_consulta": "09:20:00",
  //"dta_marcacao": "01-08-2017",
  //"des_especialidade": "OFTALMOLOGIA"

  final String dataMarcacao, dataConsulta, horaConsulta, especialidade;
  final Widget child;

  const Consulta(
      {Key key,
      this.dataMarcacao,
      this.dataConsulta,
      this.horaConsulta,
      this.especialidade,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.fromLTRB(9.0, 4.0, 9.0, 4.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          new Row(children: <Widget>[
            new Text("Consulta",
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
                    new Text("Data: " + this.dataConsulta),
                    new Text("Hora: " + this.horaConsulta),
                    new Text(this.especialidade)
                  ])),
        ],
      ),
    );
  }
}
