import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Cirugia extends StatelessWidget {
  //"num_admissao": 18007187,
  //"data_intervencao": "2018-04-08T23:00:00.000Z",
  //"hora_ini_int": "09:15:00",
  //"tempo_duracao": "01:00:00"

  final String numAdmissao, dataIntervencao, horaIni, tempoDuracao;
  final Widget child;

  const Cirugia(
      {Key key,
      this.numAdmissao,
      this.dataIntervencao,
      this.horaIni,
      this.tempoDuracao,
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
            new Text("Cirurgia",
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ))
          ]),
          new Container(
              padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              child: new Row(
                mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
            new Text("Data: "+this.dataIntervencao),
            new Text("Hora: "+this.horaIni),
            new Text("Duração: "+this.tempoDuracao)
          ])),
        ],
      ),
    );
  }
}
