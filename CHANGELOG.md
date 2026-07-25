## 3.2.0

* Added: Privacy & GDPR compliance support (global `enabled` toggle on `AnalyticsService` to dynamically opt-out of analytics).
* Added: Individual tracker toggles via `AnalyticsService.setTrackerEnabled` to enable or disable specific trackers by class type.
* Added: Unit tests verifying privacy toggles and opt-out behaviors.
* Added: Detailed documentation in README for GDPR compliance toggles.

## 3.1.0

* Added: Made `Event` a concrete class to allow direct instantiation for quick ad-hoc event logging.
* Added: Public constructor for `AnalyticsService` to enable custom instantiations (useful for dependency injection and mocking).
* Added: `AnalyticsService.reset()` method annotated with `@visibleForTesting` to reset the global singleton.
* Added: Robust unit test suite under `test/` for testing `AnalyticsService` and error isolation.
* Fixed: Wrapped tracker methods inside `AnalyticsService` with try-catch blocks to prevent errors in one tracker from blocking others.
* Fixed: Conformed `FirebaseTracker.track` return type to `void` and captured async errors locally via `catchError`.
* Fixed: Conformed parameter types in `ConsoleTracker.track` to match the base `Tracker` interface.
* Fixed: Minor typos in comments and documentation.

## 3.0.0

* Breaking: Upgraded `amplitude_flutter` to `^4.6.2`, `firebase_analytics` to `^12.4.5`, and `firebase_core` to `^4.12.1`.
* Breaking: Upgraded Dart SDK constraints in example app to support Dart 3.x.
* Changed: Migrated `AmplitudeTracker` to the new Amplitude SDK v4 API.
* Fixed: Replaced deprecated/removed `headline4` text style in the example application.
* Fixed: Resolved widget test initialization issue in the example test suite.

## 2.0.0+12

* Changed: Updated `Tracker.track` method to support Firebase Analytics params

## 1.2.0+11

* Changed: Updated `firease_core` and `firebase_analytics` dependencies

## 1.1.2+10

* Changed: Updated `firease_core`, `firebase_analytics` and `amplitude_flutter` dependencies

## 1.1.1

* Added: Made `userId` nullable

## 1.1.0

* Added: `setUserId` to `AnalyticsService`

## 1.0.0

* First release
