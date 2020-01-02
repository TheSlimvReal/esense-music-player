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
      connectedBus:this.connectedBus);

  final ESense eSense;
  final connectedBus;
  PlayerWidget({this.eSense, this.connectedBus});
}

class PlayerWidgetState extends State<PlayerWidget> {
  MusicPlayer player;
  bool playing = false;
  ESense eSense;
  EventBus connectedBus;

  PlayerWidgetState({this.eSense, this.connectedBus});

  @override
  void initState() {
    super.initState();
    this.player = MusicPlayer();
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
      if ((event as ButtonEventChanged).pressed) {
        if (this.eSense.listening) {
          print('stop listening');
          this.eSense.stopListenToSensorEvents();
        } else {
          print('start listening');
          this.eSense.startListenToSensorEvents();
        }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
    );
  }
}