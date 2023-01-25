// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:event_bus/event_bus.dart';
import 'package:eventbus_counter/counter_service.dart';
import 'package:eventbus_counter/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eventbus_counter/main.dart';

void main() {
  late EventBus testEventBus;

  setUp(() {
    testEventBus = EventBus();
    locator
      ..registerSingleton<EventBus>(testEventBus)
      ..registerSingleton<CounterService>(CounterService());
  });

  tearDown(() {
    locator.reset();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter increments should emit CounterIncremented',
      (WidgetTester tester) async {
    Future eventList = testEventBus.on<CounterIncremented>().toList();
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    // otherwise we will wait forever because the Bus will keep on listening
    testEventBus.destroy();

    final events = await eventList;
    expect(events.length, 1);

    final event = events.first;
    expect(event, isA<CounterIncremented>());
  });
}
