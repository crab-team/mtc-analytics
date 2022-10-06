/// Abstraction that define the behavior of each of the tools that we integrate later.
abstract class Tracker {
  void init();
  void setUserProperties(Map<String, dynamic> properties);
  void track(String eventName, [Map<String, dynamic>? properties]);
}
