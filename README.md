<p align="center">
	<img src="https://raw.githubusercontent.com/crab-team/mtc-analytics/main/assets/mtc_logo.png" height="80" alt="MTC Logo" />
</p>

<p align="center">
    <a href="https://pub.dev/packages/mtc_analytics"><img src="https://img.shields.io/pub/v/mtc_analytics.svg" alt="Pub.dev Badge"></a>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
    <a href="https://github.com/crab-team/mtc-analytics"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

# MTC Analytics

A lightweight, robust, and extensible Flutter package designed to simplify logging events across multiple analytics platforms simultaneously (e.g., Firebase, Amplitude, and Console).

---

## Features

With **MTC Analytics**, you can:

- 🚀 **Multi-provider dispatch:** Log events to multiple analytics engines at once.
- 🛡️ **Fault Tolerance (Safe Logging):** The service is completely fail-safe. If one tracker throws an exception (due to network drops, initialization errors, etc.), others will continue to receive events unaffected.
- 🛠️ **Extensible architecture:** Implement the simple `Tracker` interface to support any custom analytics provider.
- 🧪 **Test-friendly design:** Features an instantiable service constructor and a reset hook to seamlessly mock analytics in your widget/unit tests.
- 📝 **Flexible events:** Instantiate the base `Event` directly for quick ad-hoc event logging or subclass it for strongly-typed, reusable events.

---

## Getting Started

### Amplitude Setup
If you want to use Amplitude in iOS, make sure to add `platform :ios, '10.0'` (or higher) to your `Podfile`.
- [Amplitude Flutter SDK Documentation](https://www.docs.developers.amplitude.com/data/sdks/flutter/)

### Firebase Analytics Setup
To use Firebase Analytics, you must add your application to a Firebase project using the Firebase console.
- [Firebase Analytics Flutter Documentation](https://firebase.google.com/docs/analytics/get-started?platform=flutter)

---

## Usage

### 1. Initialization

Before setting user properties or tracking events, initialize the `AnalyticsService` with your desired list of trackers.

```dart
import 'package:mtc_analytics/mtc_analytics.dart';

void main() {
  // Initialize the analytics service with Console, Amplitude, and Firebase trackers
  AnalyticsService.instance.init([
    ConsoleTracker(),
    AmplitudeTracker(
      projectName: 'my-project-name',
      apiKey: 'amplitude-api-key',
    ),
    FirebaseTracker(),
  ]);
}
```

### 2. Set User ID & User Properties

Identify users and add segmentation properties across all configured trackers.

```dart
// Identify user
AnalyticsService.instance.setUserId('user-id-123');

// Segment user with custom properties
AnalyticsService.instance.setUserProperties({
  "name": "MTC - Flutter Team",
  "email": "team@mtc-flutter.com",
  "tier": "gold",
});
```

### 3. Log Events

#### A. Ad-hoc Events (Direct instantiation)
For quick, one-off events, you can instantiate the base `Event` class directly:

```dart
AnalyticsService.instance.track(
  Event(
    name: 'button_clicked',
    properties: {
      'button_name': 'submit',
      'screen': 'login',
    },
  ),
);
```

#### B. Structured Events (Subclassing)
For type-safe, reusable events, create a class that inherits from `Event`:

```dart
class PurchaseEvent extends Event {
  final String itemId;
  final double price;

  PurchaseEvent({required this.itemId, required this.price})
      : super(
          name: 'item_purchased',
          properties: {
            'item_id': itemId,
            'price': price,
          },
        );
}

// Log the structured event
AnalyticsService.instance.track(
  PurchaseEvent(itemId: 'prod_987', price: 29.99),
);
```

---

## Advanced

### Creating a Custom Tracker

To integrate a new analytics platform (e.g., Mixpanel, Segment, or a custom internal API), implement the `Tracker` interface:

```dart
import 'package:mtc_analytics/mtc_analytics.dart';

class MyCustomTracker implements Tracker {
  @override
  void init() {
    // Initialize your third-party SDK here
  }

  @override
  void setUserId(String? userId) {
    // Associate the user id with this platform
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    // Set user demographics/attributes
  }

  @override
  void track(String eventName, [Map<String, Object>? properties]) {
    // Send event name and properties to your custom engine
  }
}
```

### Mocking & Unit Testing

`AnalyticsService` is designed to be highly testable. You can mock tracker behavior in unit and widget tests:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mtc_analytics/mtc_analytics.dart';

class MockTracker implements Tracker {
  List<String> trackedEvents = [];

  @override
  void init() {}
  @override
  void setUserId(String? userId) {}
  @override
  void setUserProperties(Map<String, dynamic> properties) {}

  @override
  void track(String eventName, [Map<String, Object>? properties]) {
    trackedEvents.add(eventName);
  }
}

void main() {
  setUp(() {
    // Reset global singleton state between tests
    AnalyticsService.reset();
  });

  testWidgets('logs event when button is tapped', (tester) async {
    final mockTracker = MockTracker();
    AnalyticsService.instance.init([mockTracker]);

    // Build widget and trigger actions
    // ...

    expect(mockTracker.trackedEvents, contains('button_clicked'));
  });
}
```

---

## Additional Information

Visit [our official website](https://mtc-flutter.com) to learn more about More Than Code (MTC).

If you like our work, you can help us with a coffee to continue creating and collaborating with the Flutter community:

<p align="center">
    <a href="https://www.buymeacoffee.com/morethancode">
        <img src="https://raw.githubusercontent.com/crab-team/mtc-analytics/main/assets/bmc.png" height="80" alt="Buy a coffee button" />
    </a>
</p>
