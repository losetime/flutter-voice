import 'dart:convert';
import 'package:flutter/material.dart'; //卡片式主题
import 'package:flutter/cupertino.dart'; //ios式风格
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import 'home/index.dart';
import 'toolReturned/index.dart';
import 'toolReceive/index.dart';
import 'dart:developer' as developer;
import 'dart:async';
import '../utils/web_socket_channel.dart';
import 'package:ftoast/ftoast.dart';

// 动态组件
class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late HomeProvider provider;
  final List<BottomNavigationBarItem> bottomTabs = [
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.car_detailed), label: '主页'),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person), label: '我的'),
  ];

  final List<Widget> tabBodies = [
    const HomeIndex(),
    const ToolReturned(),
    const ToolReceive()
  ];

  late FlutterTts flutterTts;

  late WebSocketChannel webSocketChannel;

  List<Map> voiceList = [];

  int currentIndex = 1;
  // var currentPage;

  bool isSocketInit = false;

  @override
  void initState() {
    // currentPage = tabBodies[currentIndex];
    super.initState();
    initTts();
    Future.microtask(() => initProvider());
    if (!isSocketInit) {
      isSocketInit = true;
      // initWebSocket();
    }
  }

  @override
  void dispose() {
    webSocketChannel.dispose();
    super.dispose();
  }

  /*
   * @desc 初始化Provider
   */
  void initProvider() {
    provider = Provider.of<HomeProvider>(context, listen: false);
  }

  /*
   * @desc 初始化TTS 
   **/
  void initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("zh-CN");
    await flutterTts.setSpeechRate(0.8);
  }

  /*
   * @desc 语音播报队列
   **/
  void voiceBroadcast() {
    flutterTts.speak(voiceList[0]['content']);
    flutterTts.setCompletionHandler(() {
      voiceList.removeAt(0);
      if (voiceList.isNotEmpty) {
        voiceBroadcast();
      }
    });
  }

  /*
   * @desc 创建websocket连接
   **/
  void initWebSocket() {
    webSocketChannel = WebSocketChannel.socketIntance;
    webSocketChannel.initWebSocket(onWebsocketSuccess, context);
    Future.delayed(const Duration(milliseconds: 1000), () {
      isSocketInit = false;
    });
  }

  void onWebsocketSuccess(message) {
    FToast.toast(context, msg: '连接成功');
    Map result = jsonDecode(message);
    developer.log('输出日志', name: 'websocket响应', error: message);
    switch (result['type']) {
      // 更新列表
      case 'toolScreenData':
        provider.setSocketInfo(result['data']);
        // 判断跳转哪个页面
        String eventMark = result['data']['screenEvent'];
        switch (eventMark) {
          case 'overview':
            setState(() {
              currentIndex = 0;
            });
            break;
          case 'returned':
            setState(() {
              currentIndex = 1;
            });
            break;
          case 'recipiented':
            setState(() {
              currentIndex = 2;
            });
            break;
        }
        break;
      // 语音播报
      case 'toolLog':
        if (voiceList.isEmpty) {
          // 语音播报列表如果为空，插入数据，并启动播报
          voiceList.add(result);
          voiceBroadcast();
        } else {
          // 直接插入
          voiceList.add(result);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      // bottomNavigationBar: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     currentIndex: currentIndex,
      //     items: bottomTabs,
      //     // 点击事件
      //     onTap: (index) {
      //       setState(() {
      //         currentIndex = index;
      //         currentPage = tabBodies[currentIndex];
      //       });
      //     }),
      body: IndexedStack(index: currentIndex, children: tabBodies),
    );
  }
}
