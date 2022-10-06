import 'package:amplitude_flutter/amplitude.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

class AmplitudeTracker implements Tracker {
  final Amplitude _amplitude = Amplitude.getInstance();

  final String apiKey;

  AmplitudeTracker({required this.apiKey});

  @override
  void init() {
    _amplitude.init(apiKey);
    _amplitude.trackingSessionEvents(true);
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    _amplitude.setUserProperties(properties);
  }

  @override
  void track(String eventName, [Map<String, dynamic>? properties]) {
    _amplitude.logEvent(
      eventName,
      eventProperties: properties,
    );
  }
}
