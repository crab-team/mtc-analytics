import 'package:flutter/foundation.dart';
import 'package:mtc_analytics/src/core/event.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// This service allows interacting with the integrated trackers (Firebase Analytics, Amplitude, etc).
class AnalyticsService {
  List<Tracker>? _trackers;
  static AnalyticsService? _instance;

  /// Global toggle to enable or disable all analytics tracking (for GDPR/privacy compliance).
  /// If set to `false`, all tracking, userId, and user property updates are ignored.
  bool enabled = true;

  /// Map to track the enablement status of individual tracker types.
  final Map<Type, bool> _trackerStates = {};

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

  /// Sets whether a specific tracker type is enabled or disabled.
  void setTrackerEnabled(Type trackerType, {required bool enabled}) {
    _trackerStates[trackerType] = enabled;
  }

  /// Returns whether a specific tracker type is enabled.
  bool isTrackerEnabled(Type trackerType) {
    return _trackerStates[trackerType] ?? true;
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
    if (!enabled) return;
    if (_trackers == null) {
      throw StateError('Call init() before setting user id');
    }
    for (var tracker in _trackers!) {
      if (!isTrackerEnabled(tracker.runtimeType)) continue;
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
    if (!enabled) return;
    if (_trackers == null) {
      throw StateError('Call init() before setting user properties');
    }
    for (var tracker in _trackers!) {
      if (!isTrackerEnabled(tracker.runtimeType)) continue;
      try {
        tracker.setUserProperties(properties);
      } catch (e, stackTrace) {
        debugPrint('AnalyticsService: Failed to set user properties on ${tracker.runtimeType}: $e\n$stackTrace');
      }
    }
  }

  /// Log event in each [Tracker].
  void track(Event event) {
    if (!enabled) return;
    if (_trackers == null) {
      throw StateError('Call init() before tracking events');
    }
    for (var tracker in _trackers!) {
      if (!isTrackerEnabled(tracker.runtimeType)) continue;
      try {
        tracker.track(event.name, event.properties);
      } catch (e, stackTrace) {
        debugPrint('AnalyticsService: Failed to track event "${event.name}" on ${tracker.runtimeType}: $e\n$stackTrace');
      }
    }
  }
}
