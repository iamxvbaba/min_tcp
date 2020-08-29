///
//  Generated code. Do not modify.
//  source: abridged.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const OP$json = const {
  '1': 'OP',
  '2': const [
    const {'1': 'error', '2': 0},
    const {'1': 'open', '2': 1},
    const {'1': 'packet', '2': 2},
    const {'1': 'close', '2': 3},
    const {'1': 'heartbeat', '2': 4},
    const {'1': 'ack', '2': 5},
    const {'1': 'message', '2': 7},
    const {'1': 'data', '2': 8},
    const {'1': 'handshake', '2': 9},
    const {'1': 'flush', '2': 10},
    const {'1': 'packetCreate', '2': 11},
    const {'1': 'drain', '2': 12},
    const {'1': 'connect', '2': 13},
    const {'1': 'connect_error', '2': 14},
    const {'1': 'connect_timeout', '2': 15},
    const {'1': 'connecting', '2': 16},
    const {'1': 'disconnect', '2': 17},
    const {'1': 'reconnect', '2': 18},
    const {'1': 'reconnect_attempt', '2': 19},
    const {'1': 'reconnect_failed', '2': 20},
    const {'1': 'reconnect_error', '2': 21},
    const {'1': 'reconnecting', '2': 22},
    const {'1': 'disconnecting', '2': 23},
    const {'1': 'ping', '2': 24},
    const {'1': 'pong', '2': 25},
    const {'1': 'reqPQ', '2': 101},
    const {'1': 'resPQ', '2': 102},
    const {'1': 'reqDHParams', '2': 103},
    const {'1': 'resDHParamsOK', '2': 104},
    const {'1': 'clientDHParams', '2': 105},
    const {'1': 'dhGenResult', '2': 106},
  ],
};

const Proto$json = const {
  '1': 'Proto',
  '2': const [
    const {'1': 'from', '3': 1, '4': 1, '5': 13, '10': 'from'},
    const {'1': 'seq', '3': 3, '4': 1, '5': 3, '10': 'seq'},
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'op', '3': 2, '4': 1, '5': 14, '6': '.api.OP', '10': 'op'},
    const {'1': 'AuthKeyHash', '3': 5, '4': 1, '5': 12, '10': 'AuthKeyHash'},
    const {'1': 'pingInterval', '3': 6, '4': 1, '5': 5, '10': 'pingInterval'},
    const {'1': 'pingTimeout', '3': 7, '4': 1, '5': 5, '10': 'pingTimeout'},
  ],
};

const Response$json = const {
  '1': 'Response',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'msg', '3': 2, '4': 1, '5': 9, '10': 'msg'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

const ID$json = const {
  '1': 'ID',
  '2': const [
    const {'1': 'ids', '3': 1, '4': 3, '5': 3, '10': 'ids'},
  ],
};

