import 'package:esense_flutter/esense.dart';

abstract class GenericChecker{
  bool checkOccurrence(SensorEvent newEvent) => false;
  GenericEvent createEvent() => null;
}

abstract class GenericEvent{}