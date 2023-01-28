import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> main() async {
  final socket = await Socket.connect('0.0.0.0', 3000);
  socket.listen((Uint8List data) {
    // ignore: unused_local_variable
    final serverResponse = WebSocketChannel.connect(
      Uri.parse(''),
    );
    serverResponse.sink.add(jsonEncode({"room": "room1"}));
  }, onDone: () {
    socket.destroy();
  }, onError: (error) {
    socket.destroy();
  });
}
