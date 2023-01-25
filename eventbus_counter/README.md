# eventbus_counter

## Steps
1. Emitting
    - locator
    - mixin EventEmitter
    - Event
    - Concrete Implementation

2. Listening
    - EventListener
    - EventAware

3. Observing
**TIP:**  _an event observer listens to all events_
    - abstract EventObserver
    - Concrete Observer extends EventObserver

## In this application we also cover tests
The default test has been modified so that it can recognize the new **Event Bus** dependency. Another test has been written to test that only one event is emitted when the counter button is clicked onced
