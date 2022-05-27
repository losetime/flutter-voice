import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);

  @override
  _HomeIndex createState() => _HomeIndex();
}

enum TtsState { playing, stopped, paused, continued }

class _HomeIndex extends State<HomeIndex> {
  List toolLogList = [];

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    print('连接Socket');
    var channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.35.159:32244/person/websocket/toolScreen'));
    channel.stream.listen((message) {
      Map<String, dynamic> result = jsonDecode(message);
      if(result['type']  == 'toolLog'){
        print('连接成功');
        var temp = [...toolLogList];
        // 如果大于10条则删除最后一条
        if(temp.length > 10){
          temp.removeAt(temp.length - 1);
        }
        // 向首部插入
        temp.insert(0, result);
        setState((){
          toolLogList = temp;
        });
        // channel.sink.add('received!');
        // channel.sink.close(status.goingAway);
      }
    });
  }

  List<Widget> renderList(){
    List<Widget> toolList = [];//先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for(var item in toolLogList) {
      toolList.add(
        Container(
          padding: const EdgeInsets.all(20),//设置Container的内边距为20.0
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors:[Colors.red, Colors.orange]), //背景渐变
              border: Border(
                  bottom: BorderSide(
                    color: Colors.green,
                  )
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(item['msgTime']),
              Text(item['content']),
            ],
          ),
        ),
      );
    }
    return toolList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 56.0, // in logical pixels
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[500]),
      child: Column(
        children: renderList(),
      ),
    );
  }
}
