import 'dart:core';

import 'package:esense/esense.dart';
import 'package:esense/music/playerWidget.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// TODO: create list with available songs that shows current playing

class _MyAppState extends State<MyApp> {

  // the name of the eSense device to connect to -- change this to your own device.
  String eSenseName = 'eSense-0708';
  ESense eSense;
  EventBus connectedBus;
  String state = 'disconnected';

  @override
  void initState() {
    super.initState();
    this.eSense = new ESense();
    this.connectedBus = new EventBus();
    this.state = 'disconnected';
  }

  void connectESense({String name = ''}) {
    setState(() {
      state = 'connecting';
    });
    this.eSense.connectToESense(name: this.eSenseName)
      .then((event) {
        setState(() {
          state = 'connected';
        });
        this.connectedBus.fire(event);
    });
  }

  void disconnectESense() {
    this.eSense.disconnectFromESense()
        .then((event) {
          setState(() {
            state = 'disconnected';
          });
    });
  }

  Widget createConnectionButton(BuildContext context) {
    Widget content;
    if (this.state == 'connected') {
      content = FlatButton(
        onPressed: this.disconnectESense,
        child: Text('Disconnect', style: TextStyle(color: Colors.white),),
      );
    } else if (this.state == 'disconnected') {
      content = FlatButton(
        onPressed: () => this.deviceNameDialog(context),
        child: Text('Connect', style: TextStyle(color: Colors.white),),
      );
    } else if (this.state == 'connecting') {
      content = CircularProgressIndicator(backgroundColor: Colors.white,);
    }
    return content;
  }

  Future<void> deviceNameDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter device name'),
          content: TextFormField(
            initialValue: this.eSenseName,
            onFieldSubmitted: (event) {
              this.connectESense(name: event);
              Navigator.of(context).pop();
            },
            onChanged: (event) => this.eSenseName = event,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                this.connectESense(name: this.eSenseName);
                  Navigator.of(context).pop();
              },
              child: Text('connect'),
            )
          ],
        );
      }
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESense extended Music Player'),
        actions: <Widget>[
          this.createConnectionButton(context),
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
    );
  }
}