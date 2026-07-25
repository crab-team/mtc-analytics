/// Representation of the events to log.
class Event {
  final String name;
  final Map<String, Object>? properties;

  Event({
    required this.name,
    this.properties,
  });
}
