import 'package:flutter/material.dart'; //卡片式主题
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:dio/dio.dart';
import 'package:ftoast/ftoast.dart';
import 'package:date_format/date_format.dart';

class WebSocketChannel {
  static final WebSocketChannel _instance = WebSocketChannel._internal();
  factory WebSocketChannel() => _instance;
  WebSocketChannel._internal();

  static WebSocketChannel get socketIntance => _instance;

  late IOWebSocketChannel channel;

  late String deviceId;

  bool isFirstConnect = true;

  /*
   * @desc 创建websocket连接
   **/
  void initWebSocket(onData, context) async {
    String socketUrl = await _getSocketUrl(context);
    if (socketUrl.isNotEmpty) {
      channel = IOWebSocketChannel.connect(Uri.parse(socketUrl));
      channel.stream.listen(
          (message) => onWebsocketSuccess(message, onData, context),
          onDone: () => onWebsocketDone(onData, context),
          onError: (error) => onWebsocketError(socketUrl, context));
    } else {
      DateTime currentDate = DateTime.now();
      String nowTime = '${formatDate(currentDate, [
            yyyy,
            '-',
            mm,
            '-',
            dd
          ])} ${formatDate(currentDate, [HH, ':', nn, ':', ss])}';
      FToast.toast(
        context,
        msg: '提示',
        subMsg: '$nowTime: 域名地址不能为空, 设备id：$deviceId',
        image: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.yellow,
        ),
        imageDirection: AxisDirection.left,
        duration: 60000,
        color: Colors.black,
      );
      Future.delayed(const Duration(seconds: 10), () {
        initWebSocket(onData, context);
      });
    }
  }

  void onWebsocketSuccess(message, callback, context) {
    if (isFirstConnect) {
      FToast.toast(context, msg: '连接成功');
      isFirstConnect = false;
    }
    callback(message);
  }

  void onWebsocketError(socketUrl, context) {
    channel.sink.close(status.goingAway); //关闭连接通道
    FToast.toast(context, msg: 'websocket连接失败, 连接地址：$socketUrl');
  }

  void onWebsocketDone(onData, context) {
    FToast.toast(context, msg: '[状态]: 连接终止');
    Future.delayed(const Duration(seconds: 10), () {
      initWebSocket(onData, context);
      FToast.toast(context, msg: '[状态]: 开始重连');
      isFirstConnect = true;
    });
  }

  void dispose() {
    channel.sink.close(); //关闭连接通道
  }

  /*
   * @desc 获取设备信息
   */
  _getDeviceInfo(context) async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  /*
   * @desc 获取socketUrl
   */
  _getSocketUrl(context) async {
    String socketUrl = '';
    deviceId = await _getDeviceInfo(context);
    try {
      Response response = await Dio(BaseOptions(
        connectTimeout: 5000,
      )).get(
          'http://miwb.proxy.yunmaizhineng.com:16005/dataManager/tvMacWs/getSocketUrl?mac=$deviceId');
      var result = response.data;
      if (result['code'] == 20000) {
        socketUrl = result['data'];
      }
    } catch (e) {
      FToast.toast(
        context,
        msg: '提示',
        subMsg: '请求错误，请检查',
        image: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.yellow,
        ),
        imageDirection: AxisDirection.left,
        duration: 5000,
        color: Colors.black,
      );
    }
    return socketUrl;
  }
}
