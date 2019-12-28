import 'package:esense/events/NodDownEvent.dart';
import 'package:esense/events/NodLeftEvent.dart';
import 'package:esense/events/NodRightEvent.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import 'MusicPlayer.dart';

class PlayerWidget extends StatefulWidget {

  @override
  State createState() => PlayerWidgetState(sensorBus: sensorBus);

  final EventBus sensorBus;
  PlayerWidget({this.sensorBus});
}

class PlayerWidgetState extends State<PlayerWidget> {
  MusicPlayer player;
  bool playing = false;
  EventBus sensorBus;


  PlayerWidgetState({this.sensorBus});

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
    if (this.sensorBus != null) {
      this._registerSensorListeners();
    }
  }

  void _registerSensorListeners() {
    this.sensorBus.on<NodLeftEvent>().listen((event)=> this.player.previous());
    this.sensorBus.on<NodRightEvent>().listen((event) => this.player.next());
    this.sensorBus.on<NodDownEvent>().listen((event) => this.player.playOrPause());
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