abstract class GenericChecker{
  bool checkOccurrence(List<int> oldGyro, List<int> newGyro) => false;
  GenericEvent create() => null;
}

abstract class GenericEvent{}