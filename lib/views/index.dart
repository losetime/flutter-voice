import 'dart:convert';
import 'package:flutter/material.dart'; //卡片式主题
import 'package:flutter/cupertino.dart'; //ios式风格
import 'package:web_socket_channel/io.dart';
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

  int currentIndex = 0;
  // var currentPage;
  String socketInfo =
      '{"msgTime": "2021-12-11", "content": "放置错误222", "type": "toolLog"}';

  @override
  void initState() {
    // currentPage = tabBodies[currentIndex];
    connectSocket();
    super.initState();
  }

  void connectSocket() {
    Future.delayed(const Duration(seconds: 4), () {
      provider.setSocketInfo(jsonDecode(socketInfo));
    });
    //
    // print('连接Socket');
    // var channel = IOWebSocketChannel.connect(
    //     Uri.parse('ws://192.168.35.159:32244/person/websocket/toolScreen'));
    // channel.stream.listen((message) {
    //   Map<String, dynamic> result = jsonDecode(message);
    //   if (result['type'] == 'toolLog') {
    //     print('连接成功');
    //     var temp = [...toolLogList];
    //     // 如果大于10条则删除最后一条
    //     if (temp.length > 10) {
    //       temp.removeAt(temp.length - 1);
    //     }
    //     // 向首部插入
    //     temp.insert(0, result);
    //     setState(() {
    //       toolLogList = temp;
    //     });
    //     // channel.sink.add('received!');
    //     // channel.sink.close(status.goingAway);
    //   }
    // });
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
