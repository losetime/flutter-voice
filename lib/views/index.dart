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

  List<String> voiceList = [
    '我听别人说这世界上有一种鸟是没有脚的，它只能一直飞呀飞呀，飞累了就在风里面睡觉，这种鸟一辈子只能下地一次，那边一次就是它死亡的时候。',
    '有人就有恩怨，有恩怨就有江湖。人就是江湖，你怎么退出？',
    '当我站在瀑布前，觉得非常的难过，我总觉得，应该是两个人站在这里。',
    '我一直怀疑27岁是否还会有一见钟情的倾心。我不知道该说什么，我只是突然在那一刻很想念她。',
  ];

  int currentIndex = 0;
  // var currentPage;
  String socketInfo =
      '{"msgTime": "2021-12-11", "content": "放置错误222", "type": "toolLog"}';

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
      provider.setSocketInfo(result);
      if (voiceList.isEmpty) {
        // 插入数据，并启动播报
      } else {
        // 直接插入
      }
    });
  }

  /*
   * @desc 初始化TTS 
   **/
  void initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("zh-CN");
    await flutterTts.setSpeechRate(1);
    voiceBroadcast();
  }

  /*
   * @desc 语音播报队列
   **/
  void voiceBroadcast() {
    flutterTts.speak(voiceList[0]).then(
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
