import 'package:esense_flutter/esense.dart';

class ESense {
  String eSenseName = 'eSense-0708';
  ConnectionType status = ConnectionType.unknown;

  Map<Type, List<Function>> eventHandlers = {};

  Future<ConnectionType> _connectToESense() {

    // if you want to get the connection events when connecting, set up the listener BEFORE connecting...
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      this.status = event.type;
      return this.status;
    });

    ESenseManager.connect(eSenseName);
  }

  void _listenToESenseEvents() {
    ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

      this.eventHandlers[event.runtimeType].forEach((fun) => fun(event));
    });
  }

  registerHandler(Type type, Function func) {
    if (!this.eventHandlers.containsKey(type)) {
      this.eventHandlers[type] = [];
    }
    this.eventHandlers[type].add(func);
  }
}