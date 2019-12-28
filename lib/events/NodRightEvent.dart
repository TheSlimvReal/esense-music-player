import 'dart:async';

import 'package:esense/events/GenericEvent.dart';

class NodRightEvent implements GenericEvent {}

class NodRightChecker implements GenericChecker {
  bool moveRightDetected = false;

  @override
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) {
    if (oldGyro[1] - newGyro[1] > 4000) {
      print('first right ${oldGyro[1] - newGyro[1]}');
      this.moveRightDetected = true;
      Timer(Duration(milliseconds: 500), () {
        this.moveRightDetected = false;
        print('reset timer right');
      });
      return false;
    } else if (this.moveRightDetected && oldGyro[1] - newGyro[1] < -6000) {
      print('second right  ${oldGyro[1] - newGyro[1]}');
      this.moveRightDetected = false;
      return true;
    }
    return false;
  }

  @override
  NodRightEvent createEvent() {
    return new NodRightEvent();
  }
}


