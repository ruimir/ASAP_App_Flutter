import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

Drawer gaveta(BuildContext context) {
  return new Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the Drawer if there isn't enough vertical
    // space to fit everything.
    child: new ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        new DrawerHeader(
          child: new Image.asset('images/asap_white.png'),
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
        ),
        new ListTile(
          title: new Text('Perfil'),
          leading: new Icon(Icons.person),
          onTap: () {
            // Update the state of the app
            Navigator.of(context).pushNamed('/perfil');
            // Then close the drawer
          },
        ),
        new ListTile(
          title: new Text('Eventos clínicos agendados'),
          leading: new Icon(Icons.calendar_today),
          onTap: () {
            Navigator.of(context).pushNamed('/eventosFuturos');
          },
        ),
        new ListTile(
          title: new Text('Histórico clínico'),
          leading: new Icon(Icons.timeline),
          onTap: () {
            Navigator.of(context).pushNamed('/eventosPassados');
          },
        ),
        new ListTile(
          title: new Text('Terminar sessão'),
          leading: new Icon(Icons.power_settings_new),
          onTap: () {
            logoutUser().then((onValue) {
              Navigator.of(context).pushReplacementNamed('/boot');
            });
          },
        ),
      ],
    ),
  );
}

Future logoutUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwtKey', null);
}
