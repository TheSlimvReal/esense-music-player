import 'dart:async';

import 'package:esense/events/GenericEvent.dart';
import 'package:esense_flutter/esense.dart';

class ESense {
  String eSenseName = 'eSense-0708';
  ConnectionType status = ConnectionType.unknown;

  Map<Type, List<Function>> eSenseHandlers = {};
  List<GenericChecker> eventCheckers = [];
  bool checked = false;
  StreamSubscription sensorSubscription;

  Future<ConnectionType> connectToESense() {
    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    var resultFuture =  ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      this.status = event.type;
      return this.status;
    }).asFuture();

    ESenseManager.connect(eSenseName);
    return resultFuture;
  }

  void _listenToESenseEvents() {
    ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

      this.eSenseHandlers[event.runtimeType].forEach((fun) => fun(event));
    });
  }

  void registerSensorEvent() {

  }

  void startListenToSensorEvents() {
    this.sensorSubscription = ESenseManager.sensorEvents.listen((event) {
      for (var check in this.eventCheckers) {
      }
    })
  }

  void registerESenseHandler(Type type, Function func) {
    if (!this.eSenseHandlers.containsKey(type)) {
      this.eSenseHandlers[type] = [];
    }
    this.eSenseHandlers[type].add(func);
  }

  void registerDeviceNameReadHandler(Function func) {
    this.registerESenseHandler(DeviceNameRead, func);
  }

  void registerBatteryReadHandler(Function func) {
    this.registerESenseHandler(BatteryRead, func);
  }

  void registerButtonChangedHandler(Function func) {
    this.registerESenseHandler(ButtonEventChanged, func);
  }
}