import 'package:flutter_test/flutter_test.dart';
import 'package:mtc_analytics/mtc_analytics.dart';

class MockTracker implements Tracker {
  bool initialized = false;
  String? userId;
  Map<String, dynamic>? userProperties;
  final List<Map<String, dynamic>> trackedEvents = [];
  bool shouldThrowOnInit = false;
  bool shouldThrowOnUserId = false;
  bool shouldThrowOnUserProperties = false;
  bool shouldThrowOnTrack = false;

  @override
  void init() {
    if (shouldThrowOnInit) {
      throw Exception('MockInitError');
    }
    initialized = true;
  }

  @override
  void setUserId(String? userId) {
    if (shouldThrowOnUserId) {
      throw Exception('MockUserIdError');
    }
    this.userId = userId;
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    if (shouldThrowOnUserProperties) {
      throw Exception('MockUserPropertiesError');
    }
    userProperties = properties;
  }

  @override
  void track(String eventName, [Map<String, Object>? properties]) {
    if (shouldThrowOnTrack) {
      throw Exception('MockTrackError');
    }
    trackedEvents.add({
      'name': eventName,
      'properties': properties,
    });
  }
}

class AnotherMockTracker extends MockTracker {}

void main() {
  setUp(() {
    AnalyticsService.reset();
  });

  group('AnalyticsService - Initialization & Configuration', () {
    test('throws StateError when setUserId is called before init', () {
      final service = AnalyticsService();
      expect(() => service.setUserId('user-123'), throwsA(isA<StateError>()));
    });

    test('throws StateError when setUserProperties is called before init', () {
      final service = AnalyticsService();
      expect(() => service.setUserProperties({'age': 30}), throwsA(isA<StateError>()));
    });

    test('throws StateError when track is called before init', () {
      final service = AnalyticsService();
      expect(() => service.track(Event(name: 'test_event')), throwsA(isA<StateError>()));
    });

    test('initializes all trackers', () {
      final tracker1 = MockTracker();
      final tracker2 = MockTracker();

      final service = AnalyticsService();
      service.init([tracker1, tracker2]);

      expect(tracker1.initialized, isTrue);
      expect(tracker2.initialized, isTrue);
    });

    test('singleton behavior and reset', () {
      final tracker = MockTracker();
      AnalyticsService.instance.init([tracker]);

      expect(tracker.initialized, isTrue);

      AnalyticsService.reset();
      // Should throw StateError now as it was reset
      expect(() => AnalyticsService.instance.track(Event(name: 'event')), throwsA(isA<StateError>()));
    });
  });

  group('AnalyticsService - Propagation', () {
    late AnalyticsService service;
    late MockTracker tracker1;
    late MockTracker tracker2;

    setUp(() {
      tracker1 = MockTracker();
      tracker2 = MockTracker();
      service = AnalyticsService();
      service.init([tracker1, tracker2]);
    });

    test('propagates user id to all trackers', () {
      service.setUserId('user-999');
      expect(tracker1.userId, equals('user-999'));
      expect(tracker2.userId, equals('user-999'));
    });

    test('propagates user properties to all trackers', () {
      final props = {'membership': 'gold', 'level': 5};
      service.setUserProperties(props);
      expect(tracker1.userProperties, equals(props));
      expect(tracker2.userProperties, equals(props));
    });

    test('propagates track events to all trackers', () {
      final event = Event(name: 'button_click', properties: {'button_id': 'submit'});
      service.track(event);

      expect(tracker1.trackedEvents, hasLength(1));
      expect(tracker1.trackedEvents.first['name'], equals('button_click'));
      expect(tracker1.trackedEvents.first['properties'], equals({'button_id': 'submit'}));

      expect(tracker2.trackedEvents, hasLength(1));
      expect(tracker2.trackedEvents.first['name'], equals('button_click'));
      expect(tracker2.trackedEvents.first['properties'], equals({'button_id': 'submit'}));
    });
  });

  group('AnalyticsService - Error Isolation', () {
    test('init error in one tracker does not block others', () {
      final failingTracker = MockTracker()..shouldThrowOnInit = true;
      final successfulTracker = MockTracker();

      final service = AnalyticsService();
      service.init([failingTracker, successfulTracker]);

      expect(failingTracker.initialized, isFalse);
      expect(successfulTracker.initialized, isTrue);
    });

    test('track error in one tracker does not block others', () {
      final failingTracker = MockTracker()..shouldThrowOnTrack = true;
      final successfulTracker = MockTracker();

      final service = AnalyticsService();
      service.init([failingTracker, successfulTracker]);

      final event = Event(name: 'purchase');
      service.track(event);

      expect(failingTracker.trackedEvents, isEmpty);
      expect(successfulTracker.trackedEvents, hasLength(1));
      expect(successfulTracker.trackedEvents.first['name'], equals('purchase'));
    });

    test('setUserId error in one tracker does not block others', () {
      final failingTracker = MockTracker()..shouldThrowOnUserId = true;
      final successfulTracker = MockTracker();

      final service = AnalyticsService();
      service.init([failingTracker, successfulTracker]);

      service.setUserId('user-abc');

      expect(failingTracker.userId, isNull);
      expect(successfulTracker.userId, equals('user-abc'));
    });

    test('setUserProperties error in one tracker does not block others', () {
      final failingTracker = MockTracker()..shouldThrowOnUserProperties = true;
      final successfulTracker = MockTracker();

      final service = AnalyticsService();
      service.init([failingTracker, successfulTracker]);

      final props = {'theme': 'dark'};
      service.setUserProperties(props);

      expect(failingTracker.userProperties, isNull);
      expect(successfulTracker.userProperties, equals(props));
    });
  });

  group('Event Concrete Class', () {
    test('can instantiate Event class directly', () {
      final event = Event(name: 'ad_hoc_event', properties: {'value': 42});
      expect(event.name, equals('ad_hoc_event'));
      expect(event.properties, equals({'value': 42}));
    });
  });

  group('AnalyticsService - Privacy / GDPR (Enabled/Disabled states)', () {
    late AnalyticsService service;
    late MockTracker tracker1;
    late MockTracker tracker2;

    setUp(() {
      tracker1 = MockTracker();
      tracker2 = AnotherMockTracker();
      service = AnalyticsService();
      service.init([tracker1, tracker2]);
    });

    test('ignores tracking, setUserId, and setUserProperties when globally disabled', () {
      service.enabled = false;

      service.setUserId('user-xyz');
      service.setUserProperties({'age': 25});
      service.track(Event(name: 'click'));

      expect(tracker1.userId, isNull);
      expect(tracker2.userId, isNull);
      expect(tracker1.userProperties, isNull);
      expect(tracker2.userProperties, isNull);
      expect(tracker1.trackedEvents, isEmpty);
      expect(tracker2.trackedEvents, isEmpty);
    });

    test('ignores actions on specific disabled tracker types while allowing others', () {
      // Disable tracker1 by type, keep tracker2 enabled
      service.setTrackerEnabled(tracker1.runtimeType, enabled: false);

      expect(service.isTrackerEnabled(tracker1.runtimeType), isFalse);
      expect(service.isTrackerEnabled(tracker2.runtimeType), isTrue);

      service.setUserId('user-abc');
      service.setUserProperties({'tier': 'gold'});
      service.track(Event(name: 'purchase'));

      // tracker1 is disabled, should have no data
      expect(tracker1.userId, isNull);
      expect(tracker1.userProperties, isNull);
      expect(tracker1.trackedEvents, isEmpty);

      // tracker2 is enabled, should have data
      expect(tracker2.userId, equals('user-abc'));
      expect(tracker2.userProperties, equals({'tier': 'gold'}));
      expect(tracker2.trackedEvents, hasLength(1));
      expect(tracker2.trackedEvents.first['name'], equals('purchase'));
    });
  });
}
