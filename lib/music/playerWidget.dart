import 'dart:async';

import 'package:esense/events/NodDownEvent.dart';
import 'package:esense/events/NodLeftEvent.dart';
import 'package:esense/events/NodRightEvent.dart';
import 'package:esense_flutter/esense.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../esense.dart';
import 'MusicPlayer.dart';

class PlayerWidget extends StatefulWidget {

  @override
  State createState() => PlayerWidgetState(
      eSense: this.eSense,
      connectedBus: this.connectedBus,
      player: this.player);

  final ESense eSense;
  final connectedBus;
  final player;
  PlayerWidget({this.eSense, this.connectedBus, this.player});
}

class PlayerWidgetState extends State<PlayerWidget> {
  MusicPlayer player;
  bool playing = false;
  ESense eSense;
  EventBus connectedBus;
  bool changing = false;
  bool listeningToGestures = false;

  PlayerWidgetState({this.eSense, this.connectedBus, this.player});

  @override
  void initState() {
    super.initState();
    this.player.isPlayingStream.listen(
            (res) =>
              setState(() {
                playing = res;
              })
    );
    this.connectedBus.on().listen((event) {
      if (event.type == ConnectionType.connected) {
        this._setupESense();
      }
    });
  }

  void _setupESense() {
    this._registerSensorCheckers();
    this._registerSensorListeners();
    this.eSense.registerButtonChangedHandler((event) {
      print('called $event');
      if (!this.changing && (event as ButtonEventChanged).pressed) {
        if (this.eSense.listening) {
          print('stop listening');
          setState(() {
            listeningToGestures = false;
          });
          this.eSense.stopListenToSensorEvents();
          this.showSnackBar('Stopped listening to gestures');
        } else {
          setState(() {
            listeningToGestures = true;
          });
          this.eSense.startListenToSensorEvents();
          this.showSnackBar('Started listening to gestures');
        }
        this.changing = true;
        Timer(Duration(seconds: 1), () => this.changing = false);
      }
    });
  }

  void _registerSensorCheckers() {
    this.eSense.registerSensorEventCheck(new NodLeftChecker());
    this.eSense.registerSensorEventCheck(new NodDownChecker());
    this.eSense.registerSensorEventCheck(new NodRightChecker());
  }

  void _registerSensorListeners() {
    this.eSense.sensorEventBus.on<NodLeftEvent>()
        .listen((event) => this.player.previous());
    this.eSense.sensorEventBus.on<NodRightEvent>()
        .listen((event) => this.player.next());
    this.eSense.sensorEventBus.on<NodDownEvent>()
        .listen((event) => this.player.playOrPause());
  }

  void showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              'Gesture controll: '
                  '${this.listeningToGestures ? 'active' : 'not active'}'),
          Text(this.player.getSongTitle()),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: this.player.previous,
                child: Icon(Icons.skip_previous),
              ),
              FlatButton(
                onPressed: this.player.playOrPause,
                child: this.playing
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
              ),
              FlatButton(
                onPressed: this.player.next,
                child: Icon(Icons.skip_next)
              )
            ],
          ),
        ],
      ),
    );
  }
}