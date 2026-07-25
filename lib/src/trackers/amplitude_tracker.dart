import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/identify.dart';
import 'package:mtc_analytics/src/core/tracker.dart';

/// Amplitude Tracker implementation.
class AmplitudeTracker implements Tracker {
  late Amplitude _amplitude;

  final String projectName;
  final String apiKey;

  AmplitudeTracker({required this.projectName, required this.apiKey});

  /// Amplitude Tracker: initialization.
  /// To init Amplitude you need to provide an API KEY
  @override
  void init() {
    _amplitude = Amplitude(
      Configuration(
        apiKey: apiKey,
        instanceName: projectName,
      ),
    );
  }

  /// Amplitude Tracker: Set user id
  /// Setting a null [id] removes the user id.
  @override
  void setUserId(String? userId) {
    _amplitude.setUserId(userId);
  }
  
  /// Amplitude Tracker: User properties configuration
  @override
  void setUserProperties(Map<String, dynamic> properties) {
    final identify = Identify();
    properties.forEach((key, value) {
      identify.set(key, value);
    });
    _amplitude.identify(identify);
  }

  /// Amplitude Tracker: Log event in Amplitude
  @override
  void track(String eventName, [Map<String, Object>? properties]) {
    _amplitude.track(
      BaseEvent(
        eventName,
        eventProperties: properties,
      ),
    );
  }
}
