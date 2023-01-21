<p align="center">
	<img src="https://raw.githubusercontent.com/crab-team/mtc-analytics/main/assets/mtc_logo.png" height="80" alt="MTC Logo" />
</p>

<p align="center">
    <a href="https://pub.dev/packages/mtc_analytics"><img src="https://img.shields.io/pub/v/mtc_analytics.svg" alt="Pub.dev Badge"></a>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
    <a href="https://github.com/crab-team/mtc-analytics"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

# MTC - Analytics

All in one. This package was created to simplify the job of logging events across different analytics platforms.

## Getting Started

### Amplitude

If you want to use Amplitude in iOS, you need to add `platform :ios, '10.0'` to your Podfile.

[Amplitude - Documentation](https://www.docs.developers.amplitude.com/data/sdks/flutter/)

### Firebase Analytics

To use Firebase Analytics, you need to add your app to your Firebase project in the Firebase console.
[Firebase - Documentation](https://firebase.google.com/docs/analytics/get-started?platform=flutter)

## Features

With this package you'll can:

-   Use **built-in trackers** or add **new trackers** that you need in your application.
-   Configure **User properties**
-   Log **Events** and **Event properties**

## Usage

### Initialization

Before try to set user properties or track any event, you must initialize the `AnalyticsService` with according trackers.

```dart
List<Tracker> trackers = [MyCustomTracker()];

AnalyticsService analyticsService = AnalyticsService.instance;
analyticsService.init(trackers);
```

At this time, we already implemented a `ConsoleTracker` for debugging purpose, `AmplitudeTracker` and `FirebaseTracker`. You can use them

```dart
List<Tracker> trackers = [
    MyCustomTracker(),
    ConsoleTracker(),
    AmplitudeTracker(apiKey: 'api-key'),
    FirebaseTracker(),
];

AnalyticsService analyticsService = AnalyticsService.instance;
analyticsService.init(trackers);
```

### Set user properties

To set user properties simply call `AnalyticsService.instance.setUserProperties`

```dart
AnalyticsService.instance.setUserProperties(
    {
        "name": "MTC - Flutter Team",
        "email": "team@mtc-flutter.com",
    },
);
```

### Log events

To log events you need to create **you own event class**. For example, if the app needs to log an event when the user increments a counter:

```dart
class IncrementCounterEvent extends Event {
  final int count;

  IncrementCounterEvent({required this.count})
      : super(
          name: 'increment_count',
          properties: {'count': count},
        );
}
```

After that, you can call `AnalyticsService.instance.track` and pass it the created event

```dart
AnalyticsService.instance.track(
    IncrementCounterEvent(count: _counter),
);
```

## Additional information

Visit [our page](https://mtc-flutter.com) to know more about us!

If our content like you can help us with a coffee to continue creating and collaborating with the Flutter community
<br>

<p align="center">
    <a href="https://www.buymeacoffee.com/morethancode">
        <img src="https://raw.githubusercontent.com/crab-team/mtc-analytics/main/assets/bmc.png" height="80" alt="Buy a coffe button" />
    </a>
</p>
