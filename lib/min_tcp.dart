library min_tcp;

import 'package:logging/logging.dart';
import 'manager.dart';
import 'socket.dart';

final Logger _logger = Logger('min_tcp_client');

final Map<String, dynamic> cache = {};

Socket io(String hostname,int port, [opts]) => _create(hostname,port, opts);

Socket _create(hostname,port, opts) {
  opts = opts ?? <dynamic, dynamic>{};
  Manager io = Manager(hostname:hostname,port:port, options: opts);
  return io.socket(hostname,port,opts);
}