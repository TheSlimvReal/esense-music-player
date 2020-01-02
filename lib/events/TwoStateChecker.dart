import 'dart:async';

import 'package:esense/events/GenericEvent.dart';
import 'package:esense_flutter/esense.dart';

abstract class TwoStateChecker implements GenericChecker {
  bool firstCheckPassed = false;
  SensorEvent lastEvent;

  @override
  bool checkOccurrence(SensorEvent newEvent) {
    if (lastEvent == null) {
      this.lastEvent = newEvent;
      return false;
    }
    bool res = false;
    if (!this.firstCheckPassed
        && this.checkFirstState(this.lastEvent, newEvent)) {
      this.firstCheckPassed = true;
      Timer(Duration(milliseconds: 500), () {
        this.firstCheckPassed= false;
      });
      res = false;
    } else if (this.firstCheckPassed
        && this.checkSecondState(this.lastEvent, newEvent)) {
      this.firstCheckPassed = false;
      res = true;
    }
    this.lastEvent = newEvent;
    return res;
  }

  bool checkFirstState(SensorEvent oldEvent, SensorEvent newEvent) => false;
  bool checkSecondState(SensorEvent oldEvent, SensorEvent newEvent) => false;
}