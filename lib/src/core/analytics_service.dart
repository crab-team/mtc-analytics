import 'package:mtc_analytics/src/core/event.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

class AnalyticsService {
  static AnalyticsService? _instance;
  static List<Tracker>? _trackers;

  AnalyticsService._createInstance();

  static AnalyticsService get instance {
    _instance ??= AnalyticsService._createInstance();
    return _instance!;
  }

  void init(List<Tracker> trackers) {
    _trackers = trackers;
    for (var tracker in _trackers!) {
      tracker.init();
    }
  }

  void setUserProperties(Map<String, dynamic> properties) {
    if (_trackers == null) throw Exception('Call init() before set user properties');
    for (var tracker in _trackers!) {
      tracker.setUserProperties(properties);
    }
  }

  void track(Event event) {
    if (_trackers == null) throw Exception('Call init() before track any event');
    for (var tracker in _trackers!) {
      tracker.track(event.name, event.properties);
    }
  }
}
