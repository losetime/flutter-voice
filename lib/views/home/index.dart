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
    var channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.35.159:32244/person/websocket/toolScreen'));
    channel.stream.listen((message) {
      Map<String, dynamic> result = jsonDecode(message);
      if (result['type'] == 'toolLog') {
        print('连接成功');
        var temp = [...toolLogList];
        // 如果大于10条则删除最后一条
        if (temp.length > 10) {
          temp.removeAt(temp.length - 1);
        }
        // 向首部插入
        temp.insert(0, result);
        setState(() {
          toolLogList = temp;
        });
        // channel.sink.add('received!');
        // channel.sink.close(status.goingAway);
      }
    });
  }

  List<Widget> renderList() {
    List<Widget> toolList = []; //先建一个数组用于存放循环生成的widget
    for (var item in toolLogList) {
      toolList.add(
        Container(
          padding: const EdgeInsets.all(20), //设置Container的内边距为20.0
          decoration: const BoxDecoration(
              color: Color.fromRGBO(8, 22, 39, 1),
              // gradient:
              //     LinearGradient(colors: [Colors.red, Colors.orange]), //背景渐变
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
                left: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
                right: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item['msgTime'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                item['content'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return toolList;
  }

  @override
  Widget build(BuildContext context) {
    // return DecoratedBox(
    //   decoration: const BoxDecoration(
    //       color: Color(0xFF040404),
    //       border: Border(
    //           bottom: BorderSide(
    //         color: Color.fromRGBO(18, 155, 255, 1),
    //       ))),
    //   child: SingleChildScrollView(
    //     // height: MediaQuery.of(context).size.height, // in logical pixels
    //     // width: MediaQuery.of(context).size.width,
    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //     child: Column(
    //       children: renderList(),
    //     ),
    //   ),
    // );
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height, // in logical pixels
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Color(0xFF040404),
            border: Border(
                bottom: BorderSide(
              color: Color.fromRGBO(18, 155, 255, 1),
            ))),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20), //设置Container的内边距为20.0
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(8, 22, 39, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(18, 155, 255, 1),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    '仓位',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '工器具总数量',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ...renderList(),
          ],
        ),
      ),
    );
  }
}
