import 'package:flutter/foundation.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

class ConsoleTracker implements Tracker {
  @override
  void init() {
    debugPrint('ConsoleTracker initialized');
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    debugPrint('ConsoleTracker: Setting user properties | $properties');
  }

  @override
  void track(String eventName, [Map<String, dynamic>? properties]) {
    debugPrint('ConsoleTracker $eventName ${properties != null ? ', $properties' : ''}');
  }
}
