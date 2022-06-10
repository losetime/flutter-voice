import 'package:web_socket_channel/io.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketChannel {
  static final WebSocketChannel _instance = WebSocketChannel._internal();
  factory WebSocketChannel() => _instance;
  WebSocketChannel._internal();

  static WebSocketChannel get socketIntance => _instance;

  late IOWebSocketChannel channel;

  /*
   * @desc 创建websocket连接
   **/
  void initWebSocket(host, onData) async {
    if (host.isNotEmpty) {
      channel = IOWebSocketChannel.connect(Uri.parse(host));
      channel.stream.listen(onData,
          onDone: () => onWebsocketDone(host, onData),
          onError: (error) => onWebsocketError(host));
    } else {
      Fluttertoast.showToast(msg: '域名地址不能为空');
    }
  }

  void onWebsocketError(host) {
    channel.sink.close(status.goingAway); //关闭连接通道
    debugPrint('[状态]: websocket连接失败,已关闭');
    Fluttertoast.showToast(msg: 'websocket连接失败, 连接地址：$host');
  }

  void onWebsocketDone(host, onData) {
    // Future.delayed(const Duration(seconds: 10), () {
    //   initWebSocket(host, onData);
    //   debugPrint('[状态]: 开始重连');
    // });
  }

  void dispose() {
    channel.sink.close(); //关闭连接通道
  }
}
