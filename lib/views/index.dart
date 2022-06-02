import 'dart:convert';
import 'package:flutter/material.dart'; //卡片式主题
import 'package:flutter/cupertino.dart'; //ios式风格
import 'package:web_socket_channel/io.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import 'home/index.dart';
import 'toolReturned/index.dart';
import 'toolOut/index.dart';

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
    const ToolOut()
  ];

  late FlutterTts flutterTts;

  List<Map> voiceList = [];

  int currentIndex = 2;
  // var currentPage;

  @override
  void initState() {
    // currentPage = tabBodies[currentIndex];
    super.initState();
    initWebSocket();
    initTts();
  }

  /*
   * @desc 创建websocket连接
   **/
  void initWebSocket() async {
    IOWebSocketChannel channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.35.159:32244/person/websocket/toolScreen'));
    channel.stream.listen((message) {
      Map<String, dynamic> result = jsonDecode(message);
      print(result);
      switch (result['type']) {
        // 更新列表
        case 'toolScreenData':
          provider.setSocketInfo(result['data']);
          // 判断跳转哪个页面
          int eventMark = result['data']['screenEvent'];
          const returned = [0, 7, 8]; // 归还
          const recipiented = [1]; // 领用
          if (returned.contains(eventMark)) {
            setState(() {
              currentIndex = 1;
            });
          }
          if (recipiented.contains(eventMark)) {
            setState(() {
              currentIndex = 2;
            });
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
    });
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
    flutterTts.speak(voiceList[0]['content']).then(
          (value) => {
            voiceList.removeAt(0),
            if (voiceList.isNotEmpty)
              {
                voiceBroadcast(),
              }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeProvider>(context);
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
