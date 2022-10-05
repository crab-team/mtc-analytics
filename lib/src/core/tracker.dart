abstract class Tracker {
  void init();
  void setUserProperties(Map<String, dynamic> properties);
  void track(String eventName, [Map<String, dynamic>? properties]);
}
