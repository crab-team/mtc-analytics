import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mtc_analytics/mtc_analytics.dart';

class FirebaseTracker implements Tracker {
  late final FirebaseAnalytics _analytics;

  @override
  void init() {
    _analytics = FirebaseAnalytics.instance;
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    properties.forEach((key, value) {
      _analytics.setUserProperty(name: key, value: value);
    });
  }

  @override
  Future<void> track(String eventName,
      [Map<String, dynamic>? properties]) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: properties,
    );
  }
}
