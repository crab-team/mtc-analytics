import 'package:amplitude_flutter/amplitude.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// Amplitude Tracker implementation.
class AmplitudeTracker implements Tracker {
  final Amplitude _amplitude = Amplitude.getInstance();

  final String apiKey;

  AmplitudeTracker({required this.apiKey});

  /// Amplitude Tracker: initialization.
  /// To init Amplitude you need to provide an API KEY
  @override
  void init() {
    _amplitude.init(apiKey);
    _amplitude.trackingSessionEvents(true);
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
