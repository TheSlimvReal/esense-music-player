import 'package:esense/Events/GenericEvent.dart';

class NodRightEvent implements GenericEvent {}

class NodRightChecker implements GenericChecker {
  @override
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) {
    if (oldGyro[1] - newGyro[1] > 5000) {
      print('nod right ${oldGyro[1] - newGyro[1]}');
    }
    return oldGyro[1] - newGyro[1] > 5000;
  }

  @override
  NodRightEvent create() {
    return new NodRightEvent();
  }
}


