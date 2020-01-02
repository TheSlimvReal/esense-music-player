import 'package:esense/events/GenericEvent.dart';
import 'package:esense/events/TwoStateChecker.dart';
import 'package:esense_flutter/esense.dart';

class NodRightEvent implements GenericEvent {}

class NodRightChecker extends TwoStateChecker {
  @override
  bool checkFirstState(SensorEvent oldEvent, SensorEvent newEvent) {
    return oldEvent.gyro[1] - newEvent.gyro[1] > 4000;
  }

  @override
  bool checkSecondState(SensorEvent oldEvent, SensorEvent newEvent) {
    return oldEvent.gyro[1] - newEvent.gyro[1] < -6000;
  }

  @override
  NodRightEvent createEvent() {
    return new NodRightEvent();
  }
}


