import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> main() async {
  final channel = WebSocketChannel.connect(
    Uri.parse("ws://localhost:8181/ws/app"),
  );
  channel.sink.add(jsonEncode({"room": "room1"}));
  channel.stream.listen(
    (data) {
      print(data);
    },
    onError: (error) => print(error),
  );
  await Future.delayed(Duration(seconds: 5));

  /// Close the channel
  channel.sink.close();
}
