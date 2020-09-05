import 'package:min_tcp/min_tcp.dart';
import 'package:min_tcp/proto/abridged.pb.dart';
import 'package:min_tcp/proto/abridged.pbenum.dart';
import 'package:min_tcp/socket.dart';

void main() {
  Socket socket = io("127.0.0.1", 6666);
  print("socket:$socket");
  socket.on(OP.message, (Proto data) {
    print("处理数据哦???? :$data");
  });
}