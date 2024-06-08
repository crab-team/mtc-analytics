/// Abstraction for the events that we to log.
abstract class Event {
  final String name;
  final Map<String, Object>? properties;

  Event({
    required this.name,
    this.properties,
  });
}
