import 'package:flutter/foundation.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// Console Tracker implementation.
/// This is a tracker that we can use for debugging purposes.
///
/// For example: verify that every time we use our service we do it correctly,
/// that the events are “tracked” with the name and properties that we indicate, etc.
class ConsoleTracker implements Tracker {
  /// Console Tracker initilization.
  @override
  void init() {
    debugPrint('ConsoleTracker initialized');
  }

/// Console Tracker print configured user id
  @override
  void setUserId(String? userId) {
    debugPrint('ConsoleTracker: Seting user id -> $userId');
  }

  /// Console Tracker print user properties.
  @override
  void setUserProperties(Map<String, dynamic> properties) {
    debugPrint('ConsoleTracker: Setting user properties | $properties');
  }

  /// Console Tracker print logged event.
  @override
  void track(String eventName, [Map<String, dynamic>? properties]) {
    debugPrint(
      'ConsoleTracker $eventName ${properties != null ? ', $properties' : ''}',
    );
  }
}
