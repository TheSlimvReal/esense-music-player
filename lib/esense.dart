import 'dart:async';

import 'package:esense/events/GenericEvent.dart';
import 'package:esense/events/SensorListenEvent.dart';
import 'package:esense_flutter/esense.dart';
import 'package:event_bus/event_bus.dart';

class ESense {
  String eSenseName;
  bool listening = false;

  Map<Type, List<Function>> eSenseHandlers = {};
  List<GenericChecker> eventCheckers = [];
  bool checked = false;
  StreamSubscription sensorSubscription;
  StreamSubscription eSenseSubscription;
  EventBus sensorEventBus = new EventBus();

  Future<ConnectionEvent> connectToESense({String name = 'eSense-0708'}) {
    this.eSenseName = name;
    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    var resultFuture =  ESenseManager.connectionEvents.firstWhere((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) {
        _listenToESenseEvents();
        return true;
      }
      return false;
    });

    ESenseManager.connect(eSenseName);
    return resultFuture;
  }

  Future<ConnectionEvent> disconnectFromESense() {
    var resultFuture =  ESenseManager.connectionEvents.firstWhere((event) {

      if (event.type == ConnectionType.disconnected) {
        this.eSenseSubscription.cancel();
        return true;
      }
      return false;
    });
    ESenseManager.disconnect();
    return resultFuture;
  }

  void _listenToESenseEvents() {
    this.eSenseSubscription = ESenseManager.eSenseEvents.listen((event) {
      if (this.eSenseHandlers.containsKey(event.runtimeType)) {
        this.eSenseHandlers[event.runtimeType].forEach((fun) => fun(event));
      }
    });
  }

  void registerSensorEventCheck(GenericChecker checker) {
    this.eventCheckers.add(checker);
  }

  void startListenToSensorEvents() {
    this.listening = true;
    this.sensorEventBus.fire(new StartListenToSensorEvent());
    this.sensorSubscription = ESenseManager.sensorEvents.listen((event) {
      for (var check in this.eventCheckers) {
        if (!this.checked && check.checkOccurrence(event)) {
          this.checked = true;
          this.sensorEventBus.fire(check.createEvent());
          Timer(Duration(seconds: 2), () => this.checked = false);
        }
      }
    });
  }

  void stopListenToSensorEvents() {
    this.sensorSubscription.cancel();
    this.listening = false;
    this.sensorEventBus.fire(new StopListenToSensorEvent());
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