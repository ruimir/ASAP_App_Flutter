import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import './Utils/cirurgia.dart';
import './Utils/exame.dart';
import './Utils/consulta.dart';
import './Utils/conversaoData.dart' as conversao;

import './Utils/config.dart' as config;
import './Utils/gaveta.dart' as gaveta;

// Add import for validate package.

class EventosFuturos extends StatefulWidget {
  EventosFuturos();

  factory EventosFuturos.forDesignTime() {
    // TODO: add arguments
    return new EventosFuturos();
  }

  @override
  State<StatefulWidget> createState() => new _EventosFuturosState();
}

class _EventosFuturosState extends State<EventosFuturos> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        drawer: gaveta.gaveta(context),
        appBar: new AppBar(
          bottom: new TabBar(
            tabs: [
              new Tab(text: "Consultas"),
              new Tab(text: "Cirurgias"),
              new Tab(text: "Exames"),
            ],
          ),
          title: new Text('Eventos Futuros'),
        ),
        body: new TabBarView(
          children: [
            new FutureBuilder<dynamic>(
              future: getEventos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //return new Text(snapshot.data["cirugias"].toString());
                  return new ListView(
                      padding: new EdgeInsets.all(15.0),
                      children: [
                        new Column(children: criarListaConstltas(snapshot.data))
                      ]);
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              },
            ),
            new FutureBuilder<dynamic>(
              future: getEventos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //return new Text(snapshot.data["cirugias"].toString());
                  return new ListView(
                      padding: new EdgeInsets.all(15.0),
                      children: [
                        new Column(
                            children: criarListaCirurgias(snapshot.data)),
                      ]);
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              },
            ),
            new FutureBuilder<dynamic>(
              future: getEventos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //return new Text(snapshot.data["cirugias"].toString());
                  return new ListView(
                      padding: new EdgeInsets.all(15.0),
                      children: [
                        new Column(children: criarListaExames(snapshot.data)),
                      ]);
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> getEventos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/eventosAgendados";
  final response =
      await http.get(con, headers: {HttpHeaders.AUTHORIZATION: bearer});
  var responseJson = json.decode(response.body);
  return (responseJson);
}

List<Widget> criarListaCirurgias(Map<String, dynamic> content) {
  List<Widget> lista = [];
  lista.add(new Container(
    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
    child: new Text("Cirurgias do Utilizador",
        style: new TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
        )),
  ));
  List<dynamic> cirurgias = content["cirurgias"];
  cirurgias.forEach((element) {
    lista.add(new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new Cirugia(
            dataIntervencao:
                conversao.converterData(element["data_intervencao"].toString()),
            horaIni: element["hora_ini_int"].toString(),
            numAdmissao: element["num_admissao"].toString(),
            tempoDuracao: element["tempo_duracao"].toString()),
      ),
    ));
  });

  return lista;
}

List<Widget> criarListaExames(Map<String, dynamic> content) {
  List<Widget> lista = [];
  lista.add(new Container(
    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
    child: new Text("Exames do Utilizador",
        style: new TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
        )),
  ));
  List<dynamic> exames = content["exames"];
  exames.forEach((element) {
    lista.add(new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new Exame(
          dataMarcacao:
              conversao.converterData(element["dta_marcacao"].toString()),
          dataRegisto:
              conversao.converterData(element["dta_registo"].toString()),
          codModulo: element["cod_modulo"].toString(),
          designacao: element["designacao"].toString(),
          horaMarcacao: element["hora_marcacao"].toString(),
        ),
      ),
    ));
  });

  return lista;
}

List<Widget> criarListaConstltas(Map<String, dynamic> content) {
  List<Widget> lista = [];
  lista.add(new Container(
    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
    child: new Text("Consultas do Utilizador",
        style: new TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
        )),
  ));
  List<dynamic> consultas = content["consultas"];
  consultas.forEach((element) {
    lista.add(new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new Consulta(
          dataConsulta:
              conversao.converterData(element["dataConsulta"].toString()),
          horaConsulta: element["hora_consulta"].toString(),
          dataMarcacao:
              conversao.converterData(element["dta_marcacao"].toString()),
          especialidade: element["des_especialidade"].toString(),
        ),
      ),
    ));
  });

  return lista;
}
