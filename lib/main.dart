import 'dart:core';

import 'package:esense/esense.dart';
import 'package:esense/music/MusicPlayer.dart';
import 'package:esense/music/playerWidget.dart';
import 'package:esense/presentation/my_flutter_app_icons.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import 'events/SensorListenEvent.dart';

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
  MusicPlayer player;
  EventBus songChangedBus;
  int currentSong = -1;
  bool listeningToGestures = false;

  @override
  void initState() {
    super.initState();
    this.songChangedBus = new EventBus();
    this.player = MusicPlayer(songChangedBus: this.songChangedBus);
    this.eSense = new ESense();
    this.connectedBus = new EventBus();
    this.state = 'disconnected';
    this.songChangedBus.on()
        .listen((current) => setState(() {
          currentSong = current;
        }));
    this.eSense.sensorEventBus.on<StartListenToSensorEvent>()
        .listen((_) => setState(() {
      listeningToGestures = true;
    }));
    this.eSense.sensorEventBus.on<StopListenToSensorEvent>()
        .listen((_) => setState(() {
      listeningToGestures = false;
    }));
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
            listeningToGestures = false;
          });
    });
  }

  Widget createConnectionButton(BuildContext context) {
    Widget content;
    if (this.state == 'connected') {
      content = FlatButton(
        onPressed: this.disconnectESense,
        child: Icon(Icons.bluetooth_disabled, color: Colors.white,),
      );
    } else if (this.state == 'disconnected') {
      content = FlatButton(
        onPressed: () => this.deviceNameDialog(context),
        child: Icon(Icons.bluetooth_connected, color: Colors.white,),
      );
    } else if (this.state == 'connecting') {
      content = FlatButton(
        onPressed: () => {},
        child: CircularProgressIndicator(backgroundColor: Colors.white,),
      );    }
    return content;
  }

  Widget createGestureButton(BuildContext context) {
    FlatButton button;
    if (this.listeningToGestures == true) {
      button = FlatButton(
        onPressed: this.eSense.stopListenToSensorEvents,
        child: Container(
          child: Icon(MyFlutterApp.voice_over_off, color: Colors.blue,),
          color: Colors.white,

        ),

      );
    } else if (this.listeningToGestures == false) {
      button = FlatButton(
        onPressed: this.eSense.startListenToSensorEvents,
        child: Icon(Icons.record_voice_over, color: Colors.white,),
      );
    }
    Widget content = Visibility(
      child: button,
      visible: this.state == 'connected',
    );
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
        title: const Text('Music'),
        actions: <Widget>[
          this.createGestureButton(context),
          this.createConnectionButton(context),
        ],
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: this.player.songNames.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => this.player.playSong(index),
              child: Container(
                height: 30,
                child: Center(
                    child: Text(
                        '${this.player.songNames[index]}',
                        style: TextStyle(color: this.currentSong == index
                            ? Colors.blue : Colors.black),
                        maxLines: 1,
                    )),
              )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
      bottomNavigationBar: PlayerWidget(
        eSense: this.eSense,
        connectedBus: this.connectedBus,
        player: this.player,
      )
    );
  }
}