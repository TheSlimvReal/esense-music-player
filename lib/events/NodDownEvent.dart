import 'package:esense/events/GenericEvent.dart';
import 'package:esense/events/TwoStateChecker.dart';
import 'package:esense_flutter/esense.dart';

class NodDownEvent implements GenericEvent {}

class NodDownChecker extends TwoStateChecker {
  @override
  bool checkFirstState(SensorEvent oldEvent, SensorEvent newEvent) {
    return oldEvent.gyro[2] - newEvent.gyro[2] < -4000;
  }

  @override
  bool checkSecondState(SensorEvent oldEvent, SensorEvent newEvent) {
    return oldEvent.gyro[2] - newEvent.gyro[2] > 6000;
  }

  @override
  NodDownEvent createEvent() {
    return new NodDownEvent();
  }
}