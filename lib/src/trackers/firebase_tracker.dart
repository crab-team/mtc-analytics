import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mtc_analytics/mtc_analytics.dart';

/// Firebase Tracker implementation.
class FirebaseTracker implements Tracker {
  late final FirebaseAnalytics _analytics;

  /// Firebase Tracker initialization.
  @override
  void init() {
    _analytics = FirebaseAnalytics.instance;
  }

  /// Firebase Tracker: Set userId
  /// Setting a null [id] removes the user id.
  @override
  void setUserId(String? userId) {
    _analytics.setUserId(id: userId);
  }

  /// Firebase Tracker: User properties configuration
  @override
  void setUserProperties(Map<String, dynamic> properties) {
    properties.forEach((key, value) {
      _analytics.setUserProperty(name: key, value: value);
    });
  }

  /// Firebase Tracker: Log event in Firebase
  @override
  Future<void> track(String eventName, [Map<String, dynamic>? properties]) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: properties as Map<String, Object>?,
    );
  }
}
