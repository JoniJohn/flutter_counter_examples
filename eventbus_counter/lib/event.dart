import 'package:event_bus/event_bus.dart';
import 'package:eventbus_counter/counter_service.dart';
import 'package:get_it/get_it.dart';

GetIt get locator => GetIt.instance;

void setup() {
  locator
    ..registerSingleton(EventBus())
    ..registerSingleton(CounterService())
    ..registerSingleton(LoggingEventObserver());
}

// *********************
// * Emitting
// *********************
mixin EventEmitter {
  void emit() {
    final eventBus = locator<EventBus>();
    eventBus.fire(this);
  }
}

abstract class Event with EventEmitter {}

class CounterIncremented extends Event {}

// ********************
// * Listening
// ********************
abstract class EventListener with EventAware {
  EventListener() {
    listen();
  }
}

mixin EventAware {
  void listen() {
    locator<EventBus>().on<Event>().listen(onEvent);
  }

  Future<void> onEvent(Event event) async {}
}

// *******************
// * Observing
// *******************
abstract class EventObserver {
  EventObserver() {
    listen();
  }

  Future<void> observe(Event event);

  void listen() {
    locator<EventBus>().on<Event>().listen(onEvent);
  }

  Future<void> onEvent(Event event) async {
    await observe(event);
  }
}
