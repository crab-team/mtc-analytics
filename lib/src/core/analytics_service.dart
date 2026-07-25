import 'package:flutter/foundation.dart';
import 'package:mtc_analytics/src/core/event.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// This service allows interacting with the integrated trackers (Firebase Analytics, Amplitude, etc).
class AnalyticsService {
  List<Tracker>? _trackers;
  static AnalyticsService? _instance;

  /// Public constructor to allow direct instantiability for dependency injection and testing.
  AnalyticsService({List<Tracker>? trackers}) : _trackers = trackers;

  /// Returns the default global instance of [AnalyticsService].
  static AnalyticsService get instance {
    _instance ??= AnalyticsService();
    return _instance!;
  }

  /// Resets the global instance of [AnalyticsService]. Useful for unit tests.
  @visibleForTesting
  static void reset() {
    _instance = null;
  }

  /// Init each [Tracker].
  void init(List<Tracker> trackers) {
    _trackers = trackers;
    for (var tracker in _trackers!) {
      try {
        tracker.init();
      } catch (e, stackTrace) {
        debugPrint('AnalyticsService: Failed to initialize ${tracker.runtimeType}: $e\n$stackTrace');
      }
    }
  }

  /// Set user id for each [Tracker].
  void setUserId(String? userId) {
    if (_trackers == null) {
      throw StateError('Call init() before setting user id');
    }
    for (var tracker in _trackers!) {
      try {
        tracker.setUserId(userId);
      } catch (e, stackTrace) {
        debugPrint('AnalyticsService: Failed to set user id on ${tracker.runtimeType}: $e\n$stackTrace');
      }
    }
  }

  /// Set user properties for each [Tracker].
  ///
  /// In most analytics tools we can register user properties to better understand the type of users
  /// that use our application.
  void setUserProperties(Map<String, dynamic> properties) {
    if (_trackers == null) {
      throw StateError('Call init() before setting user properties');
    }
    for (var tracker in _trackers!) {
      try {
        tracker.setUserProperties(properties);
      } catch (e, stackTrace) {
        debugPrint('AnalyticsService: Failed to set user properties on ${tracker.runtimeType}: $e\n$stackTrace');
      }
    }
  }

  /// Log event in each [Tracker].
  void track(Event event) {
    if (_trackers == null) {
      throw StateError('Call init() before tracking events');
    }
    for (var tracker in _trackers!) {
      try {
        tracker.track(event.name, event.properties);
      } catch (e, stackTrace) {
        debugPrint('AnalyticsService: Failed to track event "${event.name}" on ${tracker.runtimeType}: $e\n$stackTrace');
      }
    }
  }
}
