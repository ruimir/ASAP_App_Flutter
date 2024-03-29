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

class FrontPageScreen extends StatefulWidget {
  FrontPageScreen();

  factory FrontPageScreen.forDesignTime() {
    // TODO: add arguments
    return new FrontPageScreen();
  }

  @override
  State<StatefulWidget> createState() => new _FrontPageState();
}

class _LoginData {
  String numUtente = '';
  int numeroTelemovel = 0;
  String morada = '';
  String email = '';
  DateTime dataNascimento = new DateTime.now();
}

class _FrontPageState extends State<FrontPageScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  DateTime _fromDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ASAP'),
        ),
        drawer: gaveta.gaveta(context),
        body: mainContent(screenSize));
  }

  Builder mainContent(Size screenSize) {
    return new Builder(builder: (BuildContext context) {
      return new FutureBuilder<dynamic>(
        future: getEventos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //return new Text(snapshot.data["cirugias"].toString());
            return new ListView(padding: new EdgeInsets.all(15.0), children: [
              new Column(children: criarListaCirurgias(snapshot.data)),
              new Column(children: criarListaExames(snapshot.data)),
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
      );
    });
  }
}

Future<dynamic> getEventos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = prefs.getString('jwtKey');
  assert(key != null);
  String bearer = "Bearer " + key;
  String con = config.connection + "webService/eventos";
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
