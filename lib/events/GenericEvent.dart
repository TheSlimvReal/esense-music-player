abstract class GenericChecker{
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) => false;
  GenericEvent createEvent() => null;
}

abstract class GenericEvent{}