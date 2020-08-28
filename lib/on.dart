import 'package:min_tcp/proto/abridged.pbenum.dart';

import 'engine/operator.dart';

///
/// Helper for subscriptions.
///
/// @param {Object|EventEmitter} obj with `Emitter` mixin or `EventEmitter`
/// @param {String} event name
/// @param {Function} callback
/// @api public
///
Destroyable on(EventEmitter obj, OP ev, EventHandler fn) {
  obj.on(ev, fn);
  return Destroyable(() => obj.off(ev, fn));
}

class Destroyable {
  Function callback;
  Destroyable(this.callback);
  void destroy() => callback();
}
