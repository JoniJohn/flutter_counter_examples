import 'package:eventbus_counter/event.dart';
import 'package:flutter/widgets.dart';

class CounterService extends ValueNotifier with EventAware {
  CounterService() : super(0) {
    listen();
  }

  @override
  Future<void> onEvent(Event event) async {
    if (event is CounterIncremented) value += 1;
  }
}

class LoggingEventObserver extends EventObserver {
  @override
  Future<void> observe(Event event) async {
    String eventName = event.runtimeType.toString();
    debugPrint(
        "[${DateTime.now().millisecondsSinceEpoch}][LoggingEventObserver][Event: $eventName]");
  }
}
