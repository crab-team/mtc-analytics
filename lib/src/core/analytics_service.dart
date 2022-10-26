import 'package:mtc_analytics/src/core/event.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// This service allow interact with the integrated trackers (Firebase Analytics, Amplitude, etc).
class AnalyticsService {
  static AnalyticsService? _instance;
  static List<Tracker>? _trackers;

  AnalyticsService._createInstance();

  static AnalyticsService get instance {
    _instance ??= AnalyticsService._createInstance();
    return _instance!;
  }

  /// Init each [Tracker].
  void init(List<Tracker> trackers) {
    _trackers = trackers;
    for (var tracker in _trackers!) {
      tracker.init();
    }
  }

  /// Set user id for each [Tracker].
  void setUserId(String userId) {
    if (_trackers == null) {
      throw Exception('Call init() before set user properties');
    }
    for (var tracker in _trackers!) {
      tracker.setUserId(userId);
    }
  }

  /// Set user properties for each [Tracker].
  ///
  /// In most analytics tools we can register user properties to better understand the type of users
  /// that use our application.
  void setUserProperties(Map<String, dynamic> properties) {
    if (_trackers == null) {
      throw Exception('Call init() before set user properties');
    }
    for (var tracker in _trackers!) {
      tracker.setUserProperties(properties);
    }
  }

  /// Log event in each [Tracker].
  void track(Event event) {
    if (_trackers == null) {
      throw Exception('Call init() before track any event');
    }
    for (var tracker in _trackers!) {
      tracker.track(event.name, event.properties);
    }
  }
}
