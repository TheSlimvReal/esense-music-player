import 'package:esense/Events/GenericEvent.dart';

class NodLeftEvent implements GenericEvent {}

class NodLeftChecker implements GenericChecker {
  @override
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) {
    if (oldGyro[1] - newGyro[1] < -5000) {
      print('nod left ${oldGyro[1] - newGyro[1]}');
    }
    return oldGyro[1] - newGyro[1] < -5000;
  }

  @override
   NodLeftEvent create() {
    return new NodLeftEvent();
  }
}


