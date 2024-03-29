import 'dart:async';

import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'verify.dart';
import 'frontPage.dart';
import 'eventosFuturos.dart';
import 'eventosPassados.dart';
import 'perfil.dart';
import 'passwordReset.dart';


import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new mainMenu());
}

class mainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.teal,
        ),
        title: 'ASAP',
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new LoginScreen(),
          '/boot': (BuildContext context) => new menu(),
          '/register': (BuildContext context) => new RegisterScreen(),
          '/verify': (BuildContext context) => new VerifyScreen(),
          '/frontPage': (BuildContext context) => new FrontPageScreen(),
          '/eventosFuturos': (BuildContext context) => new EventosFuturos(),
          '/eventosPassados': (BuildContext context) =>
              new EventosPassadosScreen(),
          '/perfil': (BuildContext context) => new PerfilScreen(),
          '/reset': (BuildContext context) => new ResetScreen(),

        },
        home: new menu());
  }
}

class menu extends StatelessWidget {
  menu();

  @override
  Widget build(BuildContext context) {
    Future<bool> islogged = userLogged();
    islogged.then((bool value) {
      print(value);
      if (value) {
        Navigator.of(context).pushReplacementNamed('/frontPage');
      } else {
        //return buildScaffold(context);
      }
    }, onError: (e) {
      print(e);
    });
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ASAP'),
      ),
      body: new ListView(
        children: [
          new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Image.asset(
              'images/asap_new.png',
              width: 100.0,
              height: 240.0,
            ),
          ),
          new Center(
            child: new Container(
              width: 150.0,
              margin: const EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Iniciar Sessão'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                  // Perform some action
                },
              ),
            ),
          ),
          new Center(
            child: new Container(
              width: 150.0,
              margin: const EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Registo'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                  // Perform some action
                },
              ),
            ),
          ),
          new Center(
            child: new Container(
              width: 150.0,
              margin: const EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Validação'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/verify');
                  // Perform some action
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Incrementing counter after click
Future<bool> userLogged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('jwtKey') == null) {
    return false;
  } else {
    return true;
  }
}
