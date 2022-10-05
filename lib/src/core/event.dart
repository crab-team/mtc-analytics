abstract class Event {
  final String name;
  final Map<String, dynamic>? properties;

  Event({
    required this.name,
    this.properties,
  });
}
