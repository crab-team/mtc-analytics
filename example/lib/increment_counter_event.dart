import 'package:mtc_analytics/mtc_analytics.dart';

class IncrementCounterEvent extends Event {
  final int count;

  IncrementCounterEvent({required this.count})
      : super(
          name: 'increment_count',
          properties: {'count': count},
        );
}
