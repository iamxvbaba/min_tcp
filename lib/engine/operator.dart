import 'dart:collection' show HashMap;

import 'package:min_tcp/proto/abridged.pb.dart';
import 'package:min_tcp/proto/abridged.pbenum.dart';


///  Handler type for handling the event emitted by an [EventEmitter].
typedef void EventHandler(Proto data);

// Generic event emitting and handling
class EventEmitter {
  // /Mapping of events to a list of event handlers
  Map<OP, List<EventHandler>> _events;

  /// Mapping of events to a list of one-time event handlers
  Map<OP, List<EventHandler>> _eventsOnce;

  /// Constructor
  EventEmitter() {
    this._events = new HashMap<OP, List<EventHandler>>();
    this._eventsOnce = new HashMap<OP, List<EventHandler>>();
  }

  /// This function triggers all the handlers currently listening
  /// to [event] and passes them [data].
  void emit(OP op, [dynamic data]) {
    final list0 = this._events[op];
    final list = list0 != null ? new List.from(list0) : null;
    list?.forEach((handler) {
      handler(data);
    });

    this._eventsOnce.remove(op)?.forEach((EventHandler handler) {
      handler(data);
    });
  }

  /// This function binds the [handler] as a listener to the [event]
  void on(OP op, EventHandler handler) {
    this._events.putIfAbsent(op, () => new List<EventHandler>());
    this._events[op].add(handler);
  }

  /// This function binds the [handler] as a listener to the first
  /// occurrence of the [event]. When [handler] is called once,
  /// it is removed.
  void once(OP op, EventHandler handler) {
    this._eventsOnce.putIfAbsent(op, () => new List<EventHandler>());
    this._eventsOnce[op].add(handler);
  }

  /// This function attempts to unbind the [handler] from the [event]
  void off(OP op, [EventHandler handler]) {
    if (handler != null) {
      this._events[op]?.remove(handler);
      this._eventsOnce[op]?.remove(handler);
      if (this._events[op]?.isEmpty == true) {
        this._events.remove(op);
      }
      if (this._eventsOnce[op]?.isEmpty == true) {
        this._eventsOnce.remove(op);
      }
    } else {
      this._events.remove(op);
      this._eventsOnce.remove(op);
    }
  }

  /// This function unbinds all the handlers for all the events.
  void clearListeners() {
    this._events = new HashMap<OP, List<EventHandler>>();
    this._eventsOnce = new HashMap<OP, List<EventHandler>>();
  }

  /// Returns whether the event has registered.
  bool hasListeners(OP op) {
    return this._events[op]?.isNotEmpty == true ||
        this._eventsOnce[op]?.isNotEmpty == true;
  }
}
