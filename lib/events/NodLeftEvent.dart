import 'dart:async';

import 'package:esense/events/GenericEvent.dart';

class NodLeftEvent implements GenericEvent {}

class NodLeftChecker implements GenericChecker {
  bool moveLeftDetected = false;

  @override
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) {
    if (oldGyro[1] - newGyro[1] < -4000) {
      print('first left ${oldGyro[1] - newGyro[1]}');
      this.moveLeftDetected = true;
      Timer(Duration(milliseconds: 500), () {
        this.moveLeftDetected = false;
        print('timer reset left');
      });
      return false;
    } else if (this.moveLeftDetected && oldGyro[1] - newGyro[1] > 6000) {
      print('second left ${oldGyro[1] - newGyro[1]}');
      this.moveLeftDetected = false;
      return true;
    }
    return false;
  }

  @override
   NodLeftEvent create() {
    return new NodLeftEvent();
  }
}


