import 'dart:async';

import 'package:esense/events/GenericEvent.dart';

class NodDownEvent implements GenericEvent {}

class NodDownChecker implements GenericChecker {
  bool moveDownDetected = false;

  @override
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) {
    if (oldGyro[2] - newGyro[2] < -4000) {
      print('first down ${oldGyro[2] - newGyro[2]}');
      this.moveDownDetected = true;
      Timer(Duration(milliseconds: 500), () {
        this.moveDownDetected = false;
        print('timer reset down');
      });
      return false;
    } else if (this.moveDownDetected && oldGyro[2] - newGyro[2] > 6000) {
      print('second down ${oldGyro[2] - newGyro[2]}');
      this.moveDownDetected = false;
      return true;
    }
    return false;
  }

  @override
  NodDownEvent createEvent() {
    return new NodDownEvent();
  }
}