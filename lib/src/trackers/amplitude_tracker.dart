import 'package:amplitude_flutter/amplitude.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// Amplitude Tracker implementation.
class AmplitudeTracker implements Tracker {
  late Amplitude _amplitude;

  final String projectName;
  final String apiKey;

  AmplitudeTracker({required this.projectName, required this.apiKey}) {
    _amplitude = Amplitude.getInstance(instanceName: projectName);
  }

  /// Amplitude Tracker: initialization.
  /// To init Amplitude you need to provide an API KEY
  @override
  void init() {
    _amplitude.init(apiKey);
    _amplitude.trackingSessionEvents(true);
  }

  /// Amplitude Tracker: Set user id
  @override
  void setUserId(String userId) {
    _amplitude.setUserId(userId);
  }
  
  /// Amplitude Tracker: User properties configuration
  @override
  void setUserProperties(Map<String, dynamic> properties) {
    _amplitude.setUserProperties(properties);
  }

  /// Amplitude Tracker: Log event in Amplitude
  @override
  void track(String eventName, [Map<String, dynamic>? properties]) {
    _amplitude.logEvent(
      eventName,
      eventProperties: properties,
    );
  }
}
