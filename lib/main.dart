import 'dart:core';

import 'package:esense/esense.dart';
import 'package:esense/music/playerWidget.dart';
import 'package:esense_flutter/esense.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // the name of the eSense device to connect to -- change this to your own device.
  String eSenseName = 'eSense-0708';
  ESense eSense;
  EventBus connectedBus;

  @override
  void initState() {
    super.initState();
    this.eSense = new ESense();
    this.connectedBus = new EventBus();
  }

  void connectESense() {
    this.eSense.connectToESense(name: this.eSenseName)
      .then((event) {
        print('firing $event');
        this.connectedBus.fire(event);
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ESense extendes Music Player'),
          actions: <Widget>[
            FlatButton(
              onPressed: this.connectESense,
              child: Text('Connect'),

            )
          ],
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              PlayerWidget(
                eSense: this.eSense,
                connectedBus: this.connectedBus,
              )
            ],
          ),
        ),
      ),
    );
  }
}