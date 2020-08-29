import 'package:min_tcp/min_tcp.dart';
import 'package:min_tcp/proto/abridged.pb.dart';
import 'package:min_tcp/proto/abridged.pbenum.dart';
import 'package:min_tcp/socket.dart';

void main() {
  Socket socket = io("127.0.0.1", 6666);
  socket.on(OP.connect_error, (Proto data) => {
    print("1.connect_error:$data")
  });
}