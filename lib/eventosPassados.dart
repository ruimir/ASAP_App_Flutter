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

// Add import for validate package.

class EventosPassadosScreen extends StatefulWidget {
  EventosPassadosScreen();

  factory EventosPassadosScreen.forDesignTime() {
    // TODO: add arguments
    return new EventosPassadosScreen();
  }

  @override
  State<StatefulWidget> createState() => new _EventosPassadosState();
}

class _EventosPassadosState extends State<EventosPassadosScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ASAP'),
        ),
        drawer: gaveta.gaveta(context),
        body: pagina());
  }

  FutureBuilder pagina() {
    return new FutureBuilder<dynamic>(
      future: getEventos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //return new Text(snapshot.data["cirugias"].toString());
          return new ListView(padding: new EdgeInsets.all(15.0), children: [
            new Column(
              children: criarHistorico(snapshot.data),
            )
          ]);
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

Future<SplayTreeMap<DateTime, String>> getEventos() async {
  SplayTreeMap<DateTime, String> eventos = new SplayTreeMap<DateTime, String>();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/eventosPassados";
  final response =
      await http.get(con, headers: {HttpHeaders.AUTHORIZATION: bearer});
  var responseJson = json.decode(response.body);
  List<dynamic> cirurgias = responseJson["cirurgias"];
  List<dynamic> exames = responseJson["exames"];
  List<dynamic> consultas = responseJson["consultas"];
  cirurgias.forEach((element) {
    eventos[DateTime.parse(element["data_intervencao"].toString())] = "Cirugia";
  });
  exames.forEach((element) {
    eventos[DateTime.parse(element["dta_marcacao"].toString())] = "Exame";
  });
  consultas.forEach((element) {
    eventos[DateTime.parse(element["dataConsulta"].toString())] = "Consulta";
  });

  return (eventos);
}

List<Widget> criarHistorico(SplayTreeMap<DateTime, String> eventos) {
  List<Widget> lista = [];
  var formatter = new DateFormat('dd-MM-yyyy');
  lista.add(new Container(
    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
    child: new Text("Histórico Médico",
        style: new TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
        )),
  ));
  eventos.forEach((data, evento) {
    Color cor = Colors.blue[50];
    if (evento == "Cirurgia") {
      cor = Color.fromARGB(255, 174, 233, 203);
    } else if (evento == "Consulta") {
      cor = Color.fromARGB(255, 252, 233, 180);
    } else if (evento == "Exame") {
      cor = Color.fromARGB(255, 253, 215, 233);
    }
    lista.add(new Card(
        child: new ExpansionTile(
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Expanded(
              child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Chip(backgroundColor: cor, label: Text(evento))
            ],
          )),
          Text(formatter.format(data).toString())
        ],
      ),
      children: <Widget>[
        new ListTile(
          title: new Text('Consultas Futuras'),
          onTap: () {},
        ),
      ],
    )));
  });

  return lista;
}
